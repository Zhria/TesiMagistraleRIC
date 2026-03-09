import time
import argparse
import signal
import numpy as np
import setup_imports

from mdclogpy import Level
from ricxappframe.xapp_frame import rmr
from utils.constants import Values

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
    def __init__(self, xapp_gen: xDevSMRMRXapp, gnb_target: str, event_trigger, sst: int, sd: int, plmn_identity: str, nr_cell_id: str):
        self.xapp_gen = xapp_gen
        self.gnb_target = gnb_target
        self.event_trigger = event_trigger*1000
        self.sst = sst
        self.sd = sd
        self.default_dest_plmn_identity = plmn_identity
        self.default_dest_nr_cell_id = nr_cell_id
        self.threshold = 20

        self.subscribed_meids = set()
        self.gnb_info_by_meid = {}
        self.rc_func_desc_by_meid = {}

        self.ind_count_by_meid = {}
        self.last_ue_count_by_meid = {}
        self.unique_ue_ids_by_meid = {}
        self.last_ue_struct_by_meid = {}

        self.pending_handover = None  # (source_meid, target_meid)
        self.handover_sent = False
        self.control_send_timestamp = None  # timing RC control request
        
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
        self._wrap_rc_handle_for_reset()
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

    def _reset_handover_state(self, reason: str) -> None:
        self.pending_handover = None
        self.handover_sent = False
        self.xapp_gen.logger.info("[xAppMonControlContainer] Reset handover state after {}".format(reason))

    def _wrap_rc_handle_for_reset(self) -> None:
        original_rc_handle = self.rc_func.handle

        def wrapped_rc_handle(xapp, summary, sbuf):
            msg_type = summary[rmr.RMR_MS_MSG_TYPE]
            if msg_type == Values.RIC_CONTROL_ACK:
                if self.control_send_timestamp:
                    rtt_ms = (time.time() - self.control_send_timestamp) * 1000
                    self.xapp_gen.logger.info(f"[TIMING] RC Control RTT (ACK): {rtt_ms:.2f} ms")
                    self.control_send_timestamp = None
                self._reset_handover_state("RIC_CONTROL_ACK")
            elif msg_type == Values.RIC_CONTROL_FAILURE:
                if self.control_send_timestamp:
                    rtt_ms = (time.time() - self.control_send_timestamp) * 1000
                    self.xapp_gen.logger.info(f"[TIMING] RC Control RTT (FAILURE): {rtt_ms:.2f} ms")
                    self.control_send_timestamp = None
                self._reset_handover_state("RIC_CONTROL_FAILURE")
            return original_rc_handle(xapp, summary, sbuf)

        self.rc_func.handle = wrapped_rc_handle

    def _has_ran_function(self, gnb_info: dict, ran_function_id: int) -> bool:
        if not gnb_info:
            return False
        ran_functions = gnb_info.get("gnb", {}).get("ranFunctions", [])
        for ran_func in ran_functions:
            if ran_func.get("ranFunctionId") == ran_function_id:
                return True
        return False

    def _ensure_meid_state(self, meid: str) -> None:
        self.ind_count_by_meid.setdefault(meid, 0)
        self.last_ue_count_by_meid.setdefault(meid, None)
        self.unique_ue_ids_by_meid.setdefault(meid, set())

    def _get_load_metric(self, meid: str) -> int:
        last_ue_count = self.last_ue_count_by_meid.get(meid)
        if last_ue_count is not None:
            return int(last_ue_count)
        return len(self.unique_ue_ids_by_meid.get(meid, set()))

    def _select_source_target(self):
        meids = [meid for meid in self.subscribed_meids if meid in self.ind_count_by_meid]
        if len(meids) < 2:
            return None, None

        def sort_key(meid: str):
            return (self._get_load_metric(meid), self.ind_count_by_meid.get(meid, 0), meid)

        source = max(meids, key=sort_key)
        targets = [meid for meid in meids if meid != source]
        if not targets:
            return None, None
        target = min(targets, key=sort_key)
        return source, target

    def _reset_all_counters(self) -> None:
        for meid in self.subscribed_meids:
            self.ind_count_by_meid[meid] = 0
            self.last_ue_count_by_meid[meid] = None
            self.unique_ue_ids_by_meid[meid] = set()
            if meid in self.last_ue_struct_by_meid:
                del self.last_ue_struct_by_meid[meid]

    def _try_send_handover(self) -> bool:
        if self.handover_sent or self.pending_handover is None:
            return False

        source_meid, target_meid = self.pending_handover

        ue_struct = self.last_ue_struct_by_meid.get(source_meid)
        if ue_struct is None:
            self.xapp_gen.logger.info("[xAppMonControlContainer] HO pending but no UE struct yet for source {}; waiting next indication".format(source_meid))
            return False

        target_info = self.gnb_info_by_meid.get(target_meid, {})
        plmn_id = target_info.get("globalNbId", {}).get("plmnId")
        nr_cell_id = target_info.get("globalNbId", {}).get("nbId")
        if not plmn_id or not nr_cell_id:
            self.xapp_gen.logger.error("[xAppMonControlContainer] Missing target globalNbId for {}; cannot send RC".format(target_meid))
            return False

        rc_desc = self.rc_func_desc_by_meid.get(source_meid)
        if rc_desc is None:
            self.xapp_gen.logger.error("[xAppMonControlContainer] Missing RC function description for {}; cannot send RC".format(source_meid))
            return False

        self.xapp_gen.logger.info("[xAppMonControlContainer] Sending HO: source={} -> target={} (plmn={} nr_cell_id={})".format(
            source_meid,
            target_meid,
            plmn_id,
            nr_cell_id,
        ))
        self.rc_func.set_nr_cell_id(nr_cell_id)
        self.rc_func.set_plmn_identity(plmn_id)
        self.control_send_timestamp = time.time()
        self.xapp_gen.logger.info(f"[TIMING] RC Control Request SENT at {self.control_send_timestamp}")
        self.rc_func.send(
            e2_node_id=source_meid,
            ran_func_dsc=rc_desc,
            ue_id_struct=ue_struct,
            control_action_id=1,
        )
        self._reset_all_counters()
        self.xapp_gen.logger.info("[xAppMonControlContainer] Reset all indication/UE counters after HO trigger")
        self.handover_sent = True
        #self.kpm_func.terminate(signal.SIGTERM, None)
        return True

    def _decode_meas_name(self, meas_info):
        if meas_info.meas_type.type.value != meas_type_enum.NAME_MEAS_TYPE:
            return None
        meas_name = meas_info.meas_type.value.name
        if not meas_name or not meas_name.buf or meas_name.len == 0:
            return None
        meas_name_bs = bytes(
            np.ctypeslib.as_array(meas_name.buf, shape=(meas_name.len,))
        )
        return meas_name_bs.decode("utf-8")

    def _decode_meas_value(self, meas_record):
        if meas_record.value.value == meas_value_e.INTEGER_MEAS_VALUE:
            return float(meas_record.union.int_val)
        if meas_record.value.value == meas_value_e.REAL_MEAS_VALUE:
            return float(meas_record.union.real_val)
        return None

    def _extract_kpm_samples(self, ind_msg_format_1):
        samples = []
        for sample_idx in range(ind_msg_format_1.meas_data_lst_len):
            meas_data = ind_msg_format_1.meas_data_lst[sample_idx]
            sample = {}
            for record_idx in range(meas_data.meas_record_len):
                if not ind_msg_format_1.meas_info_lst or record_idx >= ind_msg_format_1.meas_info_lst_len:
                    continue
                meas_info = ind_msg_format_1.meas_info_lst[record_idx]
                meas_name = self._decode_meas_name(meas_info)
                if meas_name is None:
                    continue
                meas_value = self._decode_meas_value(meas_data.meas_record_lst[record_idx])
                if meas_value is None:
                    continue
                sample[meas_name] = meas_value
            if sample:
                samples.append(sample)
        return samples

    def _format_kpm_value(self, metric_name, metric_value):
        if metric_name in ("DRB.UEThpDl", "DRB.UEThpUl"):
            return "{:.3f} Mbps".format(metric_value / 1_000_000.0)
        if metric_name in ("DRB.RlcSduTransmittedVolumeDL", "DRB.RlcSduTransmittedVolumeUL"):
            return "{:.3f} kbit".format(metric_value)
        if metric_name in ("DRB.RlcPacketDropRateDLDist", "DRB.RlcPacketLossRateULDist"):
            return "{:.3f}%".format(metric_value)
        return "{:.3f}".format(metric_value)

    def _log_kpm_metrics(self, gnbid, ue_id, meas_report_ue):
        ind_msg_format_1 = meas_report_ue.ind_msg_format_1
        samples = self._extract_kpm_samples(ind_msg_format_1)
        if not samples:
            self.xapp_gen.logger.info(
                "[KPM IND] gnb={} ue={} no decodable metrics in indication message".format(
                    gnbid, ue_id
                )
            )
            return

        granularity_ms = None
        if ind_msg_format_1.gran_period_ms:
            granularity_ms = int(ind_msg_format_1.gran_period_ms.contents.value)

        preferred_order = [
            "DRB.UEThpDl",
            "DRB.UEThpUl",
            "DRB.RlcSduTransmittedVolumeDL",
            "DRB.RlcSduTransmittedVolumeUL",
            "DRB.RlcPacketDropRateDLDist",
            "DRB.RlcPacketLossRateULDist",
        ]

        for sample_idx, sample in enumerate(samples):
            metric_names = [name for name in preferred_order if name in sample]
            metric_names.extend(sorted(name for name in sample.keys() if name not in preferred_order))
            formatted_metrics = [
                "{}={}".format(metric_name, self._format_kpm_value(metric_name, sample[metric_name]))
                for metric_name in metric_names
            ]
            prefix = "[KPM IND] gnb={} ue={} sample={}".format(gnbid, ue_id, sample_idx)
            if granularity_ms is not None:
                prefix += " granularity_ms={}".format(granularity_ms)
            self.xapp_gen.logger.info("{} {}".format(prefix, ", ".join(formatted_metrics)))

    def ind_msg_handler(self, ind_hdr, ind_msg, meid):
        """
        Handle the indication message received from the xApp
        """
        gnbid = meid.decode('utf-8')
        self._ensure_meid_state(gnbid)
        self.ind_count_by_meid[gnbid] += 1

        self.xapp_gen.logger.info("[xAppMonControlContainer] Received indication message from {} (count={})".format(
            gnbid, self.ind_count_by_meid[gnbid]
        ))
        sender_name = None
        if ind_hdr.data.kpm_ric_ind_hdr_format_1.sender_name:
            my_string = bytes(np.ctypeslib.as_array(ind_hdr.data.kpm_ric_ind_hdr_format_1.sender_name.contents.buf, shape = (ind_hdr.data.kpm_ric_ind_hdr_format_1.sender_name.contents.len,)))
            sender_name = my_string.decode('utf-8') 
        
        if sender_name is None:
            self.xapp_gen.logger.info("[xAppMonControlContainer]Sender name not specified in the indication message")
        else:
            self.xapp_gen.logger.info("[xAppMonControlContainer] Sender name: {}".format(sender_name))

        ue_id = None
        candidate_ue_struct = None
        if ind_msg.type.value == format_ind_msg_e.FORMAT_3_INDICATION_MESSAGE:
            ue_count = int(ind_msg.data.frm_3.ue_meas_report_lst_len)
            self.last_ue_count_by_meid[gnbid] = ue_count

            for i in range(ue_count):
                meas_report_ue = ind_msg.data.frm_3.meas_report_per_ue[i]
                ue_struct = meas_report_ue.ue_meas_report_lst
                if candidate_ue_struct is None:
                    candidate_ue_struct = ue_struct
                ue_id = self.kpm_func.get_ue_id(ue_struct)
                if ue_id is not None:
                    self.unique_ue_ids_by_meid[gnbid].add(int(ue_id))
                self._log_kpm_metrics(gnbid, ue_id, meas_report_ue)

        if candidate_ue_struct is not None:
            self.last_ue_struct_by_meid[gnbid] = candidate_ue_struct

        self.xapp_gen.logger.info("[xAppMonControlContainer] gnb={} sender={} ue_load={} unique_ues={}".format(
            gnbid,
            sender_name,
            self._get_load_metric(gnbid),
            len(self.unique_ue_ids_by_meid.get(gnbid, set())),
        ))

        if self.handover_sent:
            return

        if len(self.subscribed_meids) < 2:
            return

        if self.pending_handover is None:
            if self.ind_count_by_meid.get(gnbid, 0) >= self.threshold:
                source, target = self._select_source_target()
                if source and target:
                    self.pending_handover = (source, target)
                    self.xapp_gen.logger.info("[xAppMonControlContainer] HO scheduled: source={} target={} (threshold={})".format(
                        source,
                        target,
                        self.threshold,
                    ))
                    self._try_send_handover()

        if self.pending_handover is None:
            return
        self._try_send_handover()

    def sub_failed_callback(self, json_data):
        self.xapp_gen.logger.info("[xAppMonControlContainer] subscription failed: {}".format(json_data))

    def start(self):
        time.sleep(5)  # we need to wait the registration of RMR rule -> no callback defined in the osc framework

        gnb_list = self.xapp_gen.get_list_gnb_ids()
        if not gnb_list:
            self.xapp_gen.logger.info("[xAppMonControlContainer] No gNB available - terminating")
            self.kpm_func.terminate(signal.SIGTERM, None)
            return

        allowed_meids = None
        if self.gnb_target:
            allowed_meids = {s.strip() for s in self.gnb_target.split(",") if s.strip()}
            self.xapp_gen.logger.info("[xAppMonControlContainer] Filtering gNBs by --gnb_target: {}".format(sorted(allowed_meids)))

        ev_trigger_tuple = (0, self.event_trigger)

        for gnb in gnb_list:
            if allowed_meids is not None and gnb.inventory_name not in allowed_meids:
                continue

            gnb_info = self.xapp_gen.get_ran_info(e2node=gnb)
            if not gnb_info:
                self.xapp_gen.logger.error("[xAppMonControlContainer] No RAN info retrieved for {} - skipping".format(getattr(gnb, "inventory_name", gnb)))
                continue

            if gnb_info.get("connectionStatus") != "CONNECTED":
                self.xapp_gen.logger.info("[xAppMonControlContainer] E2 node {} not CONNECTED - skipping".format(gnb.inventory_name))
                continue

            if not self._has_ran_function(gnb_info, 2) or not self._has_ran_function(gnb_info, 3):
                self.xapp_gen.logger.info("[xAppMonControlContainer] E2 node {} does not expose both KPM(2) and RC(3) - skipping".format(gnb.inventory_name))
                continue

            ran_function_description = self.kpm_func.get_ran_function_description(json_ran_info=gnb_info)
            if ran_function_description is None:
                self.xapp_gen.logger.error("[xAppMonControlContainer] Cannot decode KPM function definition for {} - skipping".format(gnb.inventory_name))
                continue

            func_def_dict = ran_function_description.get_dict_of_values()
            selected_format = format_action_def_e.END_ACTION_DEFINITION
            if len(func_def_dict[format_action_def_e.FORMAT_4_ACTION_DEFINITION]) == 0:
                selected_format = format_action_def_e.FORMAT_1_ACTION_DEFINITION
            else:
                selected_format = format_action_def_e.FORMAT_4_ACTION_DEFINITION

            if selected_format == format_action_def_e.END_ACTION_DEFINITION:
                self.xapp_gen.logger.error("[xAppMonControlContainer] No supported KPM action definition format for {} - skipping".format(gnb.inventory_name))
                continue

            func_def_sub_dict = {selected_format: func_def_dict[selected_format]}

            rc_desc = self.rc_func.get_ran_function_description(json_ran_info=gnb_info)
            if rc_desc is None:
                self.xapp_gen.logger.error("[xAppMonControlContainer] Cannot decode RC function definition for {} - skipping".format(gnb.inventory_name))
                continue

            sub_start = time.time()
            status = self.kpm_func.subscribe(
                gnb=gnb,
                ev_trigger=ev_trigger_tuple,
                func_def=func_def_sub_dict,
                ran_period_ms=1000,
                sst=self.sst,
                sd=self.sd,
            )
            sub_latency_ms = (time.time() - sub_start) * 1000
            self.xapp_gen.logger.info(f"[TIMING] Subscription to {gnb.inventory_name}: {sub_latency_ms:.2f} ms (status={status})")
            if status != 201:
                self.xapp_gen.logger.error("[xAppMonControlContainer] Error subscribing to gNB {} (status={}) - skipping".format(gnb.inventory_name, status))
                continue

            meid = gnb.inventory_name
            self.subscribed_meids.add(meid)
            self.gnb_info_by_meid[meid] = gnb_info
            self.rc_func_desc_by_meid[meid] = rc_desc
            self._ensure_meid_state(meid)
            self.xapp_gen.logger.info("[xAppMonControlContainer] Subscribed to {} for KPM; RC ready".format(meid))

        if len(self.subscribed_meids) < 2:
            self.xapp_gen.logger.error("[xAppMonControlContainer] Need at least 2 subscribed E2 nodes to perform HO balancing; got {}".format(len(self.subscribed_meids)))
            self.kpm_func.terminate(signal.SIGTERM, None)
            return

        # Running xApp Thread
        self.xapp_gen.run()

def main(args):
    xapp_gen = xDevSMRMRXapp("0.0.0.0", route_file=args.route_file)
    xapp_gen.logger.set_level(string_to_level[args.log_level])
    xapp_container = xAppMonControlContainer(
        xapp_gen,
        args.gnb_target,
        args.event_trigger,
        args.sst,
        args.sd,
        args.plmn,
        args.nr_cell_id,
    )
    xapp_container.start()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="ho xApp")

    parser.add_argument("-r", "--route_file", metavar="<route_file>",
                        help="path of xApp route file",
                        type=str, default="./config/uta_rtg.rt")
    parser.add_argument("-p", "--plmn", metavar="<plmn>",
                        help="PLMN ID (fallback if only 1 E2 node is available)", type=str, default="00F110")
    parser.add_argument("-n", "--nr_cell_id", metavar="<nr_cell_id>",
                        help="NR Cell ID (fallback if only 1 E2 node is available)", type=str, default="00000000000000000000111000000001")
    parser.add_argument("-e", "--event_trigger", metavar="<event_trigger_period>",
                        help="event trigger period in seconds",
                        type=int, default=1)
    parser.add_argument("-s", "--sst", metavar="<sst>",
                        help="SST", type=int, default=1)
    parser.add_argument("-l", "--log_level", metavar="<log_level>",
                        help="Log level", type=str, default="INFO")
    parser.add_argument("-d", "--sd", metavar="<sd>",
                        help="SD", type=int, default=0)
    parser.add_argument("-g", "--gnb_target", metavar="<gnb_target>",
                        help="comma-separated allowlist of gNB inventory names (default: all CONNECTED)",
                        type=str, default=None)
                        
    args = parser.parse_args()
    main(args)
