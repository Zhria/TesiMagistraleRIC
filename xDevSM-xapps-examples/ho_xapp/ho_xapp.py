import time
import argparse
import signal
import numpy as np
import setup_imports

from mdclogpy import Level

# import xDevSM base xapp
from xDevSM.handlers.xDevSM_rmr_xapp import xDevSMRMRXapp

# import RC Radio Resource Allocation Control Decorator
from xDevSM.decorators.rc.rc_connected_mode_mobility import ConnectedModeMobilityControl
from xDevSM.decorators.kpm.kpm_frame import XappKpmFrame

# kpm related formats
from xDevSM.sm_framework.py_oran.kpm.enums import format_action_def_e
from xDevSM.sm_framework.py_oran.kpm.enums import format_ind_msg_e
from xDevSM.sm_framework.py_oran.kpm.enums import meas_type_enum
from xDevSM.sm_framework.py_oran.kpm.enums import meas_value_e


string_to_level = {
                "DEBUG": Level.DEBUG,
                "INFO": Level.INFO,
                "WARNING": Level.WARNING,
                "ERROR": Level.ERROR}

class xAppMonControlContainer():
    def __init__(self, xapp_gen: xDevSMRMRXapp, event_trigger, sst: int, sd: int,
                 plmn_identity: str, nr_cell_id: str, decision_threshold: int = 10):
        self.xapp_gen = xapp_gen
        self.event_trigger = event_trigger*1000
        self.sst = sst
        self.sd = sd
        self.dest_plmn_identity = plmn_identity
        self.dest_nr_cell_id = nr_cell_id
        self.decision_threshold = max(1, decision_threshold)
        self.nodes = {}
        self.control_dispatched = False
        
        # Adding RC - HO functionality
        self.rc_func = ConnectedModeMobilityControl(self.xapp_gen,
                                            logger=self.xapp_gen.logger,
                                            server=self.xapp_gen.server,
                                            xapp_name=self.xapp_gen.get_xapp_name(),
                                            rmr_port=self.xapp_gen.rmr_port,
                                            mrc=self.xapp_gen._mrc,
                                            http_port=self.xapp_gen.http_port,
                                            pltnamespace=self.xapp_gen.get_pltnamespace(),
                                            app_namespace=self.xapp_gen.get_app_namespace(),
                                            # control parameters
                                            plmn_identity=plmn_identity,
                                            nr_cell_id=nr_cell_id
                                            )
        # Adding KPM functionality
        self.kpm_func = XappKpmFrame(self.rc_func, 
                                     self.xapp_gen.logger, 
                                     self.xapp_gen.server, 
                                     self.xapp_gen.get_xapp_name(), 
                                     self.xapp_gen.rmr_port, 
                                     self.xapp_gen.http_port, 
                                     self.xapp_gen.get_pltnamespace(), 
                                     self.xapp_gen.get_app_namespace())
        
        self.xapp_gen.register_handler(self.kpm_func.handle)

        self.kpm_func.register_ind_msg_callback(self.ind_msg_handler)
        self.kpm_func.register_sub_fail_callback(self.sub_failed_callback)


        signal.signal(signal.SIGINT, self.kpm_func.terminate)
        signal.signal(signal.SIGTERM, self.kpm_func.terminate)


    def ind_msg_handler(self, ind_hdr, ind_msg, meid):
        """
        Handle the indication message received from the xApp
        """
        gnbid = meid.decode('utf-8')
        node = self.nodes.get(gnbid)
        if node is None:
            self.xapp_gen.logger.warning("[xAppMonControlContainer] Indication from unknown MEID {}".format(gnbid))
            return

        self.xapp_gen.logger.info("[xAppMonControlContainer] Received indication message from {}".format(gnbid))
        sender_name = None
        if ind_hdr.data.kpm_ric_ind_hdr_format_1.sender_name:
            my_string = bytes(np.ctypeslib.as_array(ind_hdr.data.kpm_ric_ind_hdr_format_1.sender_name.contents.buf, shape = (ind_hdr.data.kpm_ric_ind_hdr_format_1.sender_name.contents.len,)))
            sender_name = my_string.decode('utf-8') 
        
        if sender_name is None:
            self.xapp_gen.logger.info("[xAppMonControlContainer]Sender name not specified in the indication message")

        node["counter"] += 1
        self.xapp_gen.logger.info("[xAppMonControlContainer] Indication message count for {}: {}".format(
            gnbid, node["counter"]))
        ue_id = None
        meas_report_ue = None
        if ind_msg.type.value == format_ind_msg_e.FORMAT_3_INDICATION_MESSAGE:
            # for each ue
            meas_report_ue = ind_msg.data.frm_3.meas_report_per_ue[0] # Take the first ue only
            # ue id
            ue_id = self.kpm_func.get_ue_id(meas_report_ue.ue_meas_report_lst)

        if meas_report_ue is not None:
            node["last_meas_report"] = meas_report_ue
            score = self._extract_metric_score(meas_report_ue)
            if score is not None:
                node["metric_history"].append(score)
                node["last_metric"] = score

        self.xapp_gen.logger.info("[xAppMonControlContainer]gnb: {}, sender_name: {}, ue: {}".format(gnbid, sender_name, ue_id))

        if not self.control_dispatched and self._ready_to_decide():
            self._dispatch_control()

    def sub_failed_callback(self, json_data):
        self.xapp_gen.logger.info("[xAppMonControlContainer] subscription failed: {}".format(json_data))

    def start(self):
        time.sleep(5)  # we need to wait the registration of RMR rule -> no callback defined in the osc framework

        gnb_list = self._discover_connected_nodes()
        if not gnb_list:
            self.xapp_gen.logger.error("[Main] No connected gNBs discovered, terminating")
            self.kpm_func.terminate(signal.SIGTERM, None)
            return

        for gnb in gnb_list:
            selected_gnb, gnb_info = gnb, self.xapp_gen.get_ran_info(gnb)
            if not selected_gnb or not gnb_info:
                self.xapp_gen.logger.warning("[Main] Unable to fetch gNB info")
                continue

            self.xapp_gen.logger.info("[Main] GNB INFO ({}): {}".format(selected_gnb.inventory_name, gnb_info))
            if gnb_info.get("connectionStatus") != "CONNECTED":
                self.xapp_gen.logger.info("[Main] E2 node {} not connected, skipping".format(selected_gnb.inventory_name))
                continue

            plmn_id = gnb_info["globalNbId"]["plmnId"]
            nr_cell_id = gnb_info["globalNbId"]["nbId"]
            self.dest_plmn_identity = plmn_id
            self.dest_nr_cell_id = nr_cell_id

            ran_function_description = self.kpm_func.get_ran_function_description(json_ran_info=gnb_info)
            if ran_function_description is None:
                self.xapp_gen.logger.error("[Main] Missing KPM ranFunctionDefinition for {}".format(selected_gnb.inventory_name))
                continue
            func_def_dict = ran_function_description.get_dict_of_values()

            rc_func_desc = self.rc_func.get_ran_function_description(json_ran_info=gnb_info)
            if rc_func_desc is None:
                self.xapp_gen.logger.error("[Main] Missing RC ranFunctionDefinition for {}".format(selected_gnb.inventory_name))
                continue
            rc_func_desc.print_rc_functions()

            func_def_sub_dict = {}
            selected_format = format_action_def_e.END_ACTION_DEFINITION
            if len(func_def_dict[format_action_def_e.FORMAT_4_ACTION_DEFINITION]) == 0:
                selected_format = format_action_def_e.FORMAT_1_ACTION_DEFINITION
            else:
                selected_format = format_action_def_e.FORMAT_4_ACTION_DEFINITION
            func_def_sub_dict[selected_format] = func_def_dict[selected_format]

            ev_trigger_tuple = (0, self.event_trigger)
            status = self.kpm_func.subscribe(gnb=selected_gnb,
                                             ev_trigger=ev_trigger_tuple,
                                             func_def=func_def_sub_dict,
                                             ran_period_ms=1000,
                                             sst=self.sst,
                                             sd=self.sd)
            if status != 201:
                self.xapp_gen.logger.error("[xAppMonControlContainer] Error subscribing to gNB {}: {}".format(
                    selected_gnb.inventory_name, status))
                continue

            self.nodes[selected_gnb.inventory_name] = {
                "gnb": selected_gnb,
                "info": gnb_info,
                "plmn": plmn_id,
                "nr_cell_id": nr_cell_id,
                "rc_func_desc": rc_func_desc,
                "counter": 0,
                "metric_history": [],
                "last_metric": None,
                "last_meas_report": None,
                "subscribed": True
            }

        if not self.nodes:
            self.xapp_gen.logger.error("[Main] No successful subscriptions, terminating")
            self.kpm_func.terminate(signal.SIGTERM, None)
            return

        self.xapp_gen.run()

    def _discover_connected_nodes(self):
        nodes = []
        getter = getattr(self.xapp_gen, "get_list_gnb_ids", None)
        if callable(getter):
            try:
                nodes = [gnb for gnb in getter() if getattr(gnb, "inventory_name", None)]
            except Exception as exc:
                self.xapp_gen.logger.error("[xAppMonControlContainer] Unable to retrieve gNB list: {}".format(exc))
                nodes = []
        else:
            self.xapp_gen.logger.error("[xAppMonControlContainer] xapp_gen does not expose get_list_gnb_ids")
        if not nodes:
            self.xapp_gen.logger.warning("[xAppMonControlContainer] No gNBs returned by e2mgr")
        return nodes

    def _extract_metric_score(self, meas_report_ue):
        fmt1 = meas_report_ue.ind_msg_format_1
        if fmt1.meas_data_lst_len == 0:
            return None
        total = 0.0
        count = 0
        for idx in range(fmt1.meas_data_lst_len):
            meas_data = fmt1.meas_data_lst[idx]
            for rec_idx in range(meas_data.meas_record_len):
                record = meas_data.meas_record_lst[rec_idx]
                val_type = record.value.value
                if val_type == meas_value_e.INTEGER_MEAS_VALUE:
                    total += record.union.int_val
                    count += 1
                elif val_type == meas_value_e.REAL_MEAS_VALUE:
                    total += record.union.real_val
                    count += 1
        if count == 0:
            return None
        return total / count

    def _ready_to_decide(self):
        if not self.nodes:
            return False
        for node in self.nodes.values():
            if not node.get("subscribed"):
                continue
            if node["counter"] < self.decision_threshold:
                return False
        return True

    def _select_control_node(self):
        best_meid = None
        best_score = float("-inf")
        for meid, node in self.nodes.items():
            metric = node.get("last_metric")
            if metric is None:
                continue
            if metric > best_score:
                best_score = metric
                best_meid = meid
        if best_meid is None:
            # fallback: select node with more indications
            best_meid = max(self.nodes.items(), key=lambda item: item[1]["counter"])[0]
        return best_meid, self.nodes[best_meid]

    def _dispatch_control(self):
        selection = self._select_control_node()
        if selection is None:
            self.xapp_gen.logger.warning("[xAppMonControlContainer] No node available for control dispatch")
            return
        meid, node = selection
        meas_report = node.get("last_meas_report")
        self.xapp_gen.logger.info("[xAppMonControlContainer] Sending HO Control Action to gNB {} --> target is plmn: {}, nr_cell_id: {}".format(
            meid, self.dest_plmn_identity, self.dest_nr_cell_id))
        self.rc_func.set_nr_cell_id(self.dest_nr_cell_id)
        self.rc_func.set_plmn_identity(node.get("plmn", self.dest_plmn_identity))
        ue_payload = None
        if meas_report is not None:
            ue_payload = meas_report.ue_meas_report_lst
        self.rc_func.send(e2_node_id=node["gnb"].inventory_name,
                          ran_func_dsc=node["rc_func_desc"],
                          ue_id=ue_payload,
                          control_action_id=1)
        self.control_dispatched = True
        #self.kpm_func.terminate(signal.SIGTERM, None)

def main(args):
    xapp_gen = xDevSMRMRXapp("0.0.0.0", route_file=args.route_file)
    xapp_gen.logger.set_level(string_to_level[args.log_level])
    xapp_container = xAppMonControlContainer(xapp_gen,
                                             args.event_trigger,
                                             args.sst,
                                             args.sd,
                                             args.plmn,
                                             args.nr_cell_id)
    xapp_container.start()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="ho xApp")

    parser.add_argument("-r", "--route_file", metavar="<route_file>",
                        help="path of xApp route file",
                        type=str, default="./config/uta_rtg.rt")
    parser.add_argument("-p", "--plmn", metavar="<plmn>",
                        help="PLMN ID", type=str, default="00F110")
    parser.add_argument("-n", "--nr_cell_id", metavar="<nr_cell_id>",
                        help="NR Cell ID", type=str, default="00000000000000000000111000000001")
    parser.add_argument("-e", "--event_trigger", metavar="<event_trigger_period>",
                        help="event trigger period in seconds",
                        type=int, default=1)
    parser.add_argument("-s", "--sst", metavar="<sst>",
                        help="SST", type=int, default=1)
    parser.add_argument("-l", "--log_level", metavar="<log_level>",
                        help="Log level", type=str, default="INFO")
    parser.add_argument("-d", "--sd", metavar="<sd>",
                        help="SD", type=int, default=0)
                        
    args = parser.parse_args()
    main(args)
