import ctypes
import numpy as np
from sm_framework.py_oran.rc import RCControlHdr as hdr
from sm_framework.py_oran.rc import RCControlMsg as ctrl
from sm_framework.py_oran.rc import RCFunctionDef as funcdef
from sm_framework.py_oran.ByteArray import ByteArray
from sm_framework.py_oran.rc.enums import *

from sm_framework.lib.library_wrapper import rc_lib, wrap_functions

# Defined in Section 7.6.2.1 of the RC Service Model Specification
control_action_ids_1 = {
    "DRB QoS Configuration": 1,
    "QoS flow mapping configuration": 2, # supported
    "Logical channel configuration": 3,
    "Radio admission control": 4,
    "DRB termination control": 5,
    "DRB split ratio control": 6,
    "PDCP Duplication control": 7
}

control_action_ids_2 = {
    "DRX parameter configuration": 1,
    "SR periodicity configuration": 2,
    "SPS parameters configuration": 3,
    "Configured grant control": 4,
    "CQI table configuration": 5,
    "Slice-level PRB quota": 6 # supported
}

control_action_ids_3 = {
    "Handover Control": 1,
    "Conditional Handover Control": 2,
    "DAPS (Dual Active Protocol Stack) Handover Control": 3
}

# RIC Style Type for RIC Control Service: defined in SEction 7.6.1 of the RC Service Model Specification
ric_style_types = {
    "Radio Bearer Control": 1,
    "Radio Resource Allocation Control": 2,
    "Connected mode mobility control": 3,
    "Radio access control": 4,
    "Dual connectivity (DC) control": 5,
    "Carrier Aggregation (CA) control": 6,
    "Idle mode mobility control": 7,
    "UE information and assignment": 8,
    "Measurement Reporting Configuration control": 9,
    "Beamforming Configuration control": 10,
    "Multiple Actions Control": 255
}

# QoS flow mapping configuration: defined in Section 8.4.2.2 of the RC Service Model Specification
qos_ran_parameter_ids = {
    "DRB ID": 1,
    "List of QoS Flows to be modified in DRB": 2,
    "QoS Flow Item": 3,
    "QoS Flow Identifier": 4,
    "QoS Flow Mapping Indication": 5
}

qos_ran_parameter_id_to_name = {
    1: "DRB ID",
    2: "List of QoS Flows to be modified in DRB",
    3: "QoS Flow Item",
    4: "QoS Flow Identifier",
    5: "QoS Flow Mapping Indication"
}

prb_quota_slice_level_ids = {
    "RRM Policy Ratio List": 1,
    "RRM Policy Ratio Group": 2,
    "RRM Policy": 3,
    "RRM Policy Member List": 5,
    "RRM Policy Member": 6,
    "PLMN Identity": 7,
    "S-NSSAI": 8,
    "SST": 9,
    "SD": 10,
    "Min PRB Policy Ratio": 11,
    "Max PRB Policy Ratio": 12,
    "Dedicated PRB Policy Ratio": 13
}

ho_ids = {
 "Target Primary Cell ID": 1,
    "CHOICE Target Cell": 2,
    "NR Cell": 3,
    "NR CGI": 4,
    "E-UTRA Cell": 5,
    "E-UTRA CGI": 6,
    "List of PDU sessions for handover": 7,
    "PDU session Item for handover": 8,
    "PDU session ID": 9,
    "List of QoS flows in the PDU session": 10,
    "QoS flow Item": 11,
    "QoS Flow Identifier": 12,
    "List of DRBs for handover": 13,
    "DRB item for handover": 14,
    "DRB ID": 15,
    "List of QoS flows to be modified in DRB": 16,
    "QoS flow Item": 17,
    "QoS flow Identifier": 18,
    "List of Secondary cells to be setup": 19,
    "Secondary cell Item to be setup": 20,
    "Secondary Cell ID": 21
}

class RCControlReq(ctypes.Structure):
    _fields_ = [
        ("hdr", hdr.RCControlHdr),
        ("msg", ctrl.RCControlMsg),  # Union for the various data types
    ]

class RCControlReqEncoded(ctypes.Structure):
    _fields_ = [
        ("hdr_encoded", ByteArray),
        ("msg_encoded", ByteArray)
    ]

class RCControlReqWrapper():
    def __init__(self, logger=None):
        self.control_req: RCControlReq =  RCControlReq() # This should be built by using methods defined in this class
        self.free_hdr = wrap_functions(rc_lib, 'free_e2sm_rc_ctrl_hdr', None, [ctypes.POINTER(hdr.RCControlHdr)])
        self.free_msg = wrap_functions(rc_lib, 'free_e2sm_rc_ctrl_msg', None, [ctypes.POINTER(ctrl.RCControlMsg)])
        self.encode_hdr = wrap_functions(rc_lib, 'rc_enc_ctrl_hdr_asn', ByteArray, [ctypes.POINTER(hdr.RCControlHdr)])
        self.encode_msg = wrap_functions(rc_lib, 'rc_enc_ctrl_msg_asn', ByteArray, [ctypes.POINTER(ctrl.RCControlMsg)])
        self.logger = logger
    
    def encode(self) -> RCControlReqEncoded:
        """
        This method encodes a RCControlReq and returns the corresponding binary
        
        Be sure to call other methods of this class to build the RCControlReq
        """
        if self.control_req is None:
            return

        ctrl_req_enc = RCControlReqEncoded()
        
        ctrl_req_enc.hdr_encoded = self.encode_hdr(self.control_req.hdr)
        ctrl_req_enc.msg_encoded = self.encode_msg(self.control_req.msg)

        return ctrl_req_enc



    def get_ue_id(self, ue_info: hdr.ue_id_e2sm_t):
        ret: hdr.ue_id_e2sm_t = hdr.ue_id_e2sm_t()

        if ue_info.type == ue_id_e2sm_e.GNB_CU_UP_UE_ID_E2SM:
            print()
        elif ue_info.type == ue_id_e2sm_e.GNB_DU_UE_ID_E2SM:
            print()
        elif ue_info.type == ue_id_e2sm_e.GNB_CU_UP_UE_ID_E2SM:
            print()
        elif ue_info.type == ue_id_e2sm_e.NG_ENB_UE_ID_E2SM:
            print()
        elif ue_info.type == ue_id_e2sm_e.NG_ENB_DU_UE_ID_E2SM:
            print()
        elif ue_info.type == ue_id_e2sm_e.EN_GNB_UE_ID_E2SM:
            print()
        elif ue_info.type == ue_id_e2sm_e.ENB_UE_ID_E2SM:
            print()
        else:
            print("Unknown UE ID Type")
            

        return ret

    def print_radio_bearer_control(self):
        print("Radio Bearer Control")
        for i in range(0, self.control_req.msg.union.frmt_1.sz_ran_param):
            print("Ran Param ID: {}".format(self.control_req.msg.union.frmt_1.ran_param[i].ran_param_id))
            print("Ran Param Val Type: {}".format(self.control_req.msg.union.frmt_1.ran_param[i].ran_param_val.type.value)) 
            if qos_ran_parameter_id_to_name[self.control_req.msg.union.frmt_1.ran_param[i].ran_param_id] == "DRB ID":
                if self.control_req.msg.union.frmt_1.ran_param[i].ran_param_val.type.value == ran_parameter_val_type_e.ELEMENT_KEY_FLAG_TRUE_RAN_PARAMETER_VAL_TYPE:
                    print("Flag true drb change: {}".format(self.control_req.msg.union.frmt_1.ran_param[i].ran_param_val.union.flag_true.contents.union.int_ran))
            
            if qos_ran_parameter_id_to_name[self.control_req.msg.union.frmt_1.ran_param[i].ran_param_id] == "List of QoS Flows to be modified in DRB":
                if self.control_req.msg.union.frmt_1.ran_param[i].ran_param_val.type.value == ran_parameter_val_type_e.LIST_RAN_PARAMETER_VAL_TYPE:
                    lst = self.control_req.msg.union.frmt_1.ran_param[i].ran_param_val.union.lst.contents
                    
                    for j in range(0, lst.sz_lst_ran_param):
                        print("Element in the list: {}".format(lst.lst_ran_param[j].ran_param_struct.sz_ran_param_struct))
                        for k in range(0, lst.lst_ran_param[j].ran_param_struct.sz_ran_param_struct):
                            print("--> Param id: {} ({})".format(lst.lst_ran_param[j].ran_param_struct.ran_param_struct[k].ran_param_id, qos_ran_parameter_id_to_name[lst.lst_ran_param[j].ran_param_struct.ran_param_struct[k].ran_param_id]))
                            print("--> Param Type: {}".format(lst.lst_ran_param[j].ran_param_struct.ran_param_struct[k].ran_param_val.type.value))
                            
                            if lst.lst_ran_param[j].ran_param_struct.ran_param_struct[k].ran_param_val.type.value == ran_parameter_val_type_e.ELEMENT_KEY_FLAG_TRUE_RAN_PARAMETER_VAL_TYPE:
                                # We need to check the type integer/bool and so on
                                print("--> Flag True Param Value {}".format(lst.lst_ran_param[j].ran_param_struct.ran_param_struct[k].ran_param_val.union.flag_true.contents.union.int_ran))
                            elif lst.lst_ran_param[j].ran_param_struct.ran_param_struct[k].ran_param_val.type.value == ran_parameter_val_type_e.ELEMENT_KEY_FLAG_FALSE_RAN_PARAMETER_VAL_TYPE:
                                print("--> Flag False Param Value {}".format(lst.lst_ran_param[j].ran_param_struct.ran_param_struct[k].ran_param_val.union.flag_false.contents.union.int_ran))

                            print("--")
    
    def print_radio_resource_allocation_control(self):
        print("Radio Resource Allocation Control")
        print("Detailed information not implemented yet for this type of control")

    def print_ctrl_req(self):
        # Header
        print("--- RC Control Request Header ---")
        self.log_header_details()

        # TODO: Needs refactoring based on the type of control action
        # Message 
        print("--- RC Control Request Msg ---")
        print("Format: {}".format(self.control_req.msg.format.value))
        if self.control_req.hdr.union.frmt_1.ric_style_type == ric_style_types["Radio Bearer Control"]:
            self.print_radio_bearer_control()
        elif self.control_req.hdr.union.frmt_1.ric_style_type == ric_style_types["Radio Resource Allocation Control"]:
            self.print_radio_resource_allocation_control()
        else:
            print("Log info not implemented for this type of control action")
        

    def log_header_details(self):
        """
        Print a human readable view of every field that ends up in the RC control header.
        """
        if not self.control_req or not hasattr(self.control_req, "hdr"):
            print("[RCControlReqWrapper] No RCControlHdr to inspect")
            return

        hdr = self.control_req.hdr
        fmt_val = int(getattr(hdr.format, "value", hdr.format))
        fmt_name = self._enum_name(e2sm_rc_ctrl_hdr_e, fmt_val)
        print("Format: {} ({})".format(fmt_val, fmt_name))

        if fmt_val == e2sm_rc_ctrl_hdr_e.FORMAT_1_E2SM_RC_CTRL_HDR:
            style = int(hdr.union.frmt_1.ric_style_type)
            style_name = self._style_name(style)
            print("RIC Style Type: {} ({})".format(style, style_name))
            ctrl_act = int(hdr.union.frmt_1.ctrl_act_id)
            print("Control Action ID: {}".format(ctrl_act))
            if hdr.union.frmt_1.ric_ctrl_decision:
                dec_val = int(hdr.union.frmt_1.ric_ctrl_decision.contents.value)
                dec_name = self._enum_name(ric_ctrl_decision_e, dec_val)
                print("RIC Control Decision: {} ({})".format(dec_val, dec_name))
            else:
                print("RIC Control Decision: None")
            self._log_ue_id_details(hdr.union.frmt_1.ue_id)
        else:
            print("[RCControlReqWrapper] Unsupported RC control header format {}".format(fmt_val))

    def _enum_name(self, enum_cls, value):
        """
        Utility helper that maps the numeric value of a ctypes enum to its python name.
        """
        for attr in dir(enum_cls):
            if attr.startswith("_"):
                continue
            attr_val = getattr(enum_cls, attr)
            if attr_val == value:
                return attr
        return "UNKNOWN"

    def _style_name(self, style_id):
        for name, value in ric_style_types.items():
            if value == style_id:
                return name
        return "unknown-style"

    def _log_ue_id_details(self, ue_id: hdr.ue_id_e2sm_t):
        ue_type_val = int(getattr(ue_id.type, "value", ue_id.type))
        ue_type_name = self._enum_name(ue_id_e2sm_e, ue_type_val)
        print("UE ID Type: {} ({})".format(ue_type_val, ue_type_name))

        if ue_type_val == ue_id_e2sm_e.GNB_UE_ID_E2SM:
            self._log_gnb_fields(ue_id.union.gnb)
        elif ue_type_val == ue_id_e2sm_e.GNB_DU_UE_ID_E2SM:
            self._log_gnb_du_fields(ue_id.union.gnb_du)
        elif ue_type_val == ue_id_e2sm_e.GNB_CU_UP_UE_ID_E2SM:
            self._log_gnb_cu_up_fields(ue_id.union.gnb_cu_up)
        elif ue_type_val == ue_id_e2sm_e.NG_ENB_UE_ID_E2SM:
            self._log_ng_enb_fields(ue_id.union.ng_enb)
        elif ue_type_val == ue_id_e2sm_e.NG_ENB_DU_UE_ID_E2SM:
            self._log_ng_enb_du_fields(ue_id.union.ng_enb_du)
        elif ue_type_val == ue_id_e2sm_e.EN_GNB_UE_ID_E2SM:
            self._log_en_gnb_fields(ue_id.union.en_gnb)
        elif ue_type_val == ue_id_e2sm_e.ENB_UE_ID_E2SM:
            self._log_enb_fields(ue_id.union.enb)
        else:
            print("  [UE] No logger implemented for type {}".format(ue_type_name))

    def _log_gnb_fields(self, gnb):
        print("  [gNB UE] amf_ue_ngap_id={}".format(gnb.amf_ue_ngap_id))
        print("  [gNB UE] GUAMI={}".format(self._format_guami(gnb.guami)))
        print("  [gNB UE] gnb_cu_ue_f1ap_ids={}".format(self._dump_uint32_array(gnb.gnb_cu_ue_f1ap_lst, gnb.gnb_cu_ue_f1ap_lst_len)))
        print("  [gNB UE] gnb_cu_cp_ue_e1ap_ids={}".format(self._dump_uint32_array(gnb.gnb_cu_cp_ue_e1ap_lst, gnb.gnb_cu_cp_ue_e1ap_lst_len)))
        print("  [gNB UE] ran_ue_id={}".format(self._safe_ptr_value(gnb.ran_ue_id)))
        print("  [gNB UE] ng_ran_node_ue_xnap_id={}".format(self._safe_ptr_value(gnb.ng_ran_node_ue_xnap_id)))
        if gnb.global_gnb_id:
            print("  [gNB UE] global_gnb_id={}".format(self._format_global_gnb_id(gnb.global_gnb_id.contents)))
        else:
            print("  [gNB UE] global_gnb_id=None")
        if gnb.global_ng_ran_node_id:
            print("  [gNB UE] global_ng_ran_node_id={}".format(self._format_global_ng_ran_node_id(gnb.global_ng_ran_node_id.contents)))
        else:
            print("  [gNB UE] global_ng_ran_node_id=None")

    def _log_gnb_du_fields(self, gnb_du):
        print("  [gNB-DU UE] gnb_cu_ue_f1ap={}".format(gnb_du.gnb_cu_ue_f1ap))
        print("  [gNB-DU UE] ran_ue_id={}".format(self._safe_ptr_value(gnb_du.ran_ue_id)))

    def _log_gnb_cu_up_fields(self, gnb_cu_up):
        print("  [gNB-CU-UP UE] gnb_cu_cp_ue_e1ap={}".format(gnb_cu_up.gnb_cu_cp_ue_e1ap))
        print("  [gNB-CU-UP UE] ran_ue_id={}".format(self._safe_ptr_value(gnb_cu_up.ran_ue_id)))

    def _log_ng_enb_fields(self, ng_enb):
        print("  [NG-eNB UE] amf_ue_ngap_id={}".format(ng_enb.amf_ue_ngap_id))
        print("  [NG-eNB UE] GUAMI={}".format(self._format_guami(ng_enb.guami)))
        print("  [NG-eNB UE] ng_enb_cu_ue_w1ap_id={}".format(self._safe_ptr_value(ng_enb.ng_enb_cu_ue_w1ap_id)))
        print("  [NG-eNB UE] ng_ran_node_ue_xnap_id={}".format(self._safe_ptr_value(ng_enb.ng_ran_node_ue_xnap_id)))
        if ng_enb.global_ng_enb_id:
            print("  [NG-eNB UE] global_ng_enb_id={}".format(self._format_global_ng_enb_id(ng_enb.global_ng_enb_id.contents)))
        else:
            print("  [NG-eNB UE] global_ng_enb_id=None")
        if ng_enb.global_ng_ran_node_id:
            print("  [NG-eNB UE] global_ng_ran_node_id={}".format(self._format_global_ng_ran_node_id(ng_enb.global_ng_ran_node_id.contents)))
        else:
            print("  [NG-eNB UE] global_ng_ran_node_id=None")

    def _log_ng_enb_du_fields(self, ng_enb_du):
        print("  [NG-eNB-DU UE] ng_enb_cu_ue_w1ap_id={}".format(ng_enb_du.ng_enb_cu_ue_w1ap_id))

    def _log_en_gnb_fields(self, en_gnb):
        print("  [EN-gNB UE] enb_ue_x2ap_id={}".format(en_gnb.enb_ue_x2ap_id))
        print("  [EN-gNB UE] enb_ue_x2ap_id_extension={}".format(self._safe_ptr_value(en_gnb.enb_ue_x2ap_id_extension)))
        print("  [EN-gNB UE] global_enb_id={}".format(self._format_global_enb_id(en_gnb.global_enb_id)))
        if en_gnb.gnb_cu_ue_f1ap_lst:
            print("  [EN-gNB UE] gnb_cu_ue_f1ap list present (length not advertised)")
        else:
            print("  [EN-gNB UE] gnb_cu_ue_f1ap list absent")
        print("  [EN-gNB UE] gnb_cu_cp_ue_e1ap_ids={}".format(self._dump_uint32_array(en_gnb.gnb_cu_cp_ue_e1ap_lst, en_gnb.gnb_cu_cp_ue_e1ap_lst_len)))
        print("  [EN-gNB UE] ran_ue_id={}".format(self._safe_ptr_value(en_gnb.ran_ue_id)))

    def _log_enb_fields(self, enb):
        print("  [eNB UE] mme_ue_s1ap_id={}".format(enb.mme_ue_s1ap_id))
        print("  [eNB UE] gummei={}".format(self._format_gummei(enb.gummei)))
        print("  [eNB UE] enb_ue_x2ap_id={}".format(self._safe_ptr_value(enb.enb_ue_x2ap_id)))
        print("  [eNB UE] enb_ue_x2ap_id_extension={}".format(self._safe_ptr_value(enb.enb_ue_x2ap_id_extension)))
        print("  [eNB UE] global_enb_id={}".format(self._format_global_enb_id(enb.global_enb_id)))

    def _format_plmn(self, plmn):
        if not plmn:
            return "None"
        return "mcc={} mnc={} (digits={})".format(plmn.mcc, plmn.mnc, plmn.mnc_digit_len)

    def _format_guami(self, guami):
        if not guami:
            return "None"
        return "plmn=({}) amf_region={} amf_set={} amf_pointer={}".format(
            self._format_plmn(guami.plmn_id),
            guami.amf_region_id,
            guami.amf_set_id,
            guami.amf_ptr
        )

    def _format_gummei(self, gummei):
        if not gummei:
            return "None"
        return "plmn=({}) mme_group_id={} mme_code={}".format(
            self._format_plmn(gummei.plmn_id),
            gummei.mme_group_id,
            gummei.mme_code
        )

    def _format_global_gnb_id(self, global_id):
        return "plmn=({}) type={} ({}) nb_id={}".format(
            self._format_plmn(global_id.plmn_id),
            int(getattr(global_id.type, "value", global_id.type)),
            self._enum_name(gnb_type_id_e, int(getattr(global_id.type, "value", global_id.type))),
            global_id.union.gnb_id.nb_id
        )

    def _format_global_ng_enb_id(self, global_id):
        type_val = int(getattr(global_id.type, "value", global_id.type))
        type_name = self._enum_name(ng_enb_type_id_e, type_val)
        if type_val == ng_enb_type_id_e.MACRO_NG_ENB_TYPE_ID:
            identifier = global_id.union.macro_ng_enb_id
        elif type_val == ng_enb_type_id_e.SHORT_MACRO_NG_ENB_TYPE_ID:
            identifier = global_id.union.short_macro_ng_enb_id
        elif type_val == ng_enb_type_id_e.LONG_MACRO_NG_ENB_TYPE_ID:
            identifier = global_id.union.long_macro_ng_enb_id
        else:
            identifier = None
        return "plmn=({}) type={} ({}) identifier={}".format(
            self._format_plmn(global_id.plmn_id),
            type_val,
            type_name,
            identifier
        )

    def _format_global_enb_id(self, global_id_ptr):
        if not global_id_ptr:
            return "None"
        global_id = global_id_ptr.contents if hasattr(global_id_ptr, "contents") else global_id_ptr
        type_val = int(getattr(global_id.type, "value", global_id.type))
        type_name = self._enum_name(enb_type_id_e, type_val)
        if type_val == enb_type_id_e.MACRO_ENB_TYPE_ID:
            identifier = global_id.union.macro_enb_id
        elif type_val == enb_type_id_e.HOME_ENB_TYPE_ID:
            identifier = global_id.union.home_enb_id
        elif type_val == enb_type_id_e.SHORT_MACRO_ENB_TYPE_ID:
            identifier = global_id.union.short_macro_enb_id
        elif type_val == enb_type_id_e.LONG_MACRO_ENB_TYPE_ID:
            identifier = global_id.union.long_macro_enb_id
        else:
            identifier = None
        return "plmn=({}) type={} ({}) identifier={}".format(
            self._format_plmn(global_id.plmn_id),
            type_val,
            type_name,
            identifier
        )

    def _format_global_ng_ran_node_id(self, node):
        type_val = int(getattr(node.type, "value", node.type))
        type_name = self._enum_name(ng_ran_node_type_id_e, type_val)
        if type_val == ng_ran_node_type_id_e.GNB_GLOBAL_TYPE_ID:
            embedded = self._format_global_gnb_id(node.union.global_gnb_id)
        elif type_val == ng_ran_node_type_id_e.NG_ENB_GLOBAL_TYPE_ID:
            embedded = self._format_global_ng_enb_id(node.union.global_ng_enb_id)
        else:
            embedded = "None"
        return "type={} ({}) node={}".format(type_val, type_name, embedded)

    def _safe_ptr_value(self, ptr):
        if ptr:
            return ptr.contents.value
        return None

    def _dump_uint32_array(self, ptr, length):
        if ptr and length:
            return [ptr[i] for i in range(length)]
        return []

    def fill_DRB_param(self, index, drb_id=1):
        print("Filling index {} in drb".format(index))
        self.control_req.msg.union.frmt_1.ran_param[index].ran_param_id = qos_ran_parameter_ids["DRB ID"]
        self.control_req.msg.union.frmt_1.ran_param[index].ran_param_val.type = ran_parameter_val_type_e.ELEMENT_KEY_FLAG_TRUE_RAN_PARAMETER_VAL_TYPE
        flag_true_value = ctrl.ran_parameter_value_t()
        flag_true_value.type = ran_parameter_value_e.INTEGER_RAN_PARAMETER_VALUE
        flag_true_value.union.int_ran = drb_id

        flag_true_ptr = ctypes.pointer(flag_true_value)
        # self.control_req.msg.union.frmt_1.ran_param[index].ran_param_val.union.flag_true = ran_parameter_value_t()
        self.control_req.msg.union.frmt_1.ran_param[index].ran_param_val.union.flag_true = flag_true_ptr


    def fill_qos_param(self, index, qos_flow_id=10, qos_flow_mapping_indication=1):
        print("Filling index {} in qos".format(index))
        self.control_req.msg.union.frmt_1.ran_param[index].ran_param_id = qos_ran_parameter_ids["List of QoS Flows to be modified in DRB"]
        self.control_req.msg.union.frmt_1.ran_param[index].ran_param_val.type = ran_parameter_val_type_e.LIST_RAN_PARAMETER_VAL_TYPE
        
        # Initialize value_list
        value_list = ctrl.ran_param_list_t()
        value_list.sz_lst_ran_param = 1
        lst_param_type = ctrl.lst_ran_param_t * value_list.sz_lst_ran_param
        value_list.lst_ran_param = lst_param_type()


        # Initialize the first list element
        value_list.lst_ran_param[0].ran_param_struct.sz_ran_param_struct = 2
        lst_param_struct_type = ctrl.seq_ran_param_t * value_list.lst_ran_param[0].ran_param_struct.sz_ran_param_struct
        value_list.lst_ran_param[0].ran_param_struct.ran_param_struct = lst_param_struct_type()


        value_list.lst_ran_param[0].ran_param_struct.ran_param_struct[0].ran_param_id = qos_ran_parameter_ids["QoS Flow Identifier"]
        value_list.lst_ran_param[0].ran_param_struct.ran_param_struct[0].ran_param_val.type = ran_parameter_val_type_e.ELEMENT_KEY_FLAG_TRUE_RAN_PARAMETER_VAL_TYPE

        flag_true_value = ctrl.ran_parameter_value_t()
        flag_true_value.type = ran_parameter_value_e.INTEGER_RAN_PARAMETER_VALUE
        flag_true_value.union.int_ran = qos_flow_id
        value_list.lst_ran_param[0].ran_param_struct.ran_param_struct[0].ran_param_val.union.flag_true = ctypes.pointer(flag_true_value)

        value_list.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_id = qos_ran_parameter_ids["QoS Flow Mapping Indication"]
        value_list.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.type = ran_parameter_val_type_e.ELEMENT_KEY_FLAG_FALSE_RAN_PARAMETER_VAL_TYPE
        flag_false_value = ctrl.ran_parameter_value_t()
        flag_false_value.type = ran_parameter_value_e.INTEGER_RAN_PARAMETER_VALUE
        flag_false_value.union.int_ran = qos_flow_mapping_indication
        value_list.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.flag_false = ctypes.pointer(flag_false_value)

        self.control_req.msg.union.frmt_1.ran_param[index].ran_param_val.union.lst = ctypes.pointer(value_list)

    def qos_flow_mapping_config_handler(self, ctrl_act: funcdef.seq_ctrl_act_2_t, sz_ran_param: ctypes.c_size_t, drb_id=1, qos_flow_id=10, qos_flow_mapping_indication=1 ):
        # in this case only DRB ID and list of qos flows to be modified in DRB are supported
        for i in range(0, sz_ran_param):
            if ctrl_act.assoc_ran_param[i].id == qos_ran_parameter_ids["DRB ID"]:
                self.fill_DRB_param(i, drb_id=drb_id)
            elif ctrl_act.assoc_ran_param[i].id == qos_ran_parameter_ids["List of QoS Flows to be modified in DRB"]:
                self.fill_qos_param(i, qos_flow_id=qos_flow_id, qos_flow_mapping_indication=qos_flow_mapping_indication)
            else:
                print("QoS parameter not supported {}".format(ctrl_act.assoc_ran_param[0].id))
            
    def rrm_prb_policy_ratio_handler(self, ctrl_act: funcdef.seq_ctrl_act_2_t, sz_ran_param: ctypes.c_size_t, plmn_identity: str, sst, sd, min_prb, max_prb, dedicated_prb):
       

        param_name_bytes = bytes(np.ctypeslib.as_array(ctrl_act.assoc_ran_param[0].name.buf, shape=(ctrl_act.assoc_ran_param[0].name.len,)))
        param_name = param_name_bytes.decode('utf-8')
        print("Setting Parameter: {}".format(param_name))

        PLMN = ByteArray()
        PLMN.from_hex(plmn_identity)
       

        # S-NSSAI encoding
        sst_value = sst.to_bytes(1, byteorder='big')
        sst_byte_array = ByteArray()
        sst_byte_array.len = len(sst_value)
        sst_byte_array.buf = (ctypes.c_uint8 * len(sst_value))(*sst_value)
        sd_value = sd.to_bytes(3, byteorder='big')
        sd_byte_array = ByteArray()
        sd_byte_array.len = len(sd_value)
        sd_byte_array.buf = (ctypes.c_uint8 * len(sd_value))(*sd_value)


        # Single Param containing an RRM Policy Ratio List
        # Creating RRM Policy Ratio List
        self.control_req.msg.union.frmt_1.ran_param[0].ran_param_id = prb_quota_slice_level_ids["RRM Policy Ratio List"]
        self.control_req.msg.union.frmt_1.ran_param[0].ran_param_val.type = ran_parameter_val_type_e.LIST_RAN_PARAMETER_VAL_TYPE
        # Filling RRM Policy Ratio List
        rrm_policy_ratio_list = ctrl.ran_param_list_t()
        rrm_policy_ratio_list.sz_lst_ran_param = 1
        lst_param_type = ctrl.lst_ran_param_t * rrm_policy_ratio_list.sz_lst_ran_param
        rrm_policy_ratio_list.lst_ran_param = lst_param_type()
        
        # >RRM Policy Ratio Group -> 2
        rrm_policy_ratio_list.lst_ran_param[0].ran_param_struct.sz_ran_param_struct = 1
        intern_strct_type = ctrl.seq_ran_param_t * rrm_policy_ratio_list.lst_ran_param[0].ran_param_struct.sz_ran_param_struct
        rrm_policy_ratio_list.lst_ran_param[0].ran_param_struct.ran_param_struct = intern_strct_type()
        rrm_policy_ratio_list.lst_ran_param[0].ran_param_struct.ran_param_struct[0].ran_param_id = prb_quota_slice_level_ids["RRM Policy Ratio Group"]
        rrm_policy_ratio_list.lst_ran_param[0].ran_param_struct.ran_param_struct[0].ran_param_val.type = ran_parameter_val_type_e.STRUCTURE_RAN_PARAMETER_VAL_TYPE
        rrm_policy_ratio_list.lst_ran_param[0].ran_param_struct.ran_param_struct[0].ran_param_val.union.strct = ctypes.pointer(ctrl.ran_param_struct_t())
        ratio_group = rrm_policy_ratio_list.lst_ran_param[0].ran_param_struct.ran_param_struct[0].ran_param_val.union.strct.contents
        ratio_group.sz_ran_param_struct = 4  # We have 4 elements in the structure
        ratio_group_type = ctrl.seq_ran_param_t * ratio_group.sz_ran_param_struct
        ratio_group.ran_param_struct = ratio_group_type()
        

        # First Element of the structure: >>RRM Policy
        ratio_group.ran_param_struct[0].ran_param_id = prb_quota_slice_level_ids["RRM Policy"]
        ratio_group.ran_param_struct[0].ran_param_val.type = ran_parameter_val_type_e.STRUCTURE_RAN_PARAMETER_VAL_TYPE
        # Allocating struct
        ratio_group.ran_param_struct[0].ran_param_val.union.strct = ctypes.pointer(ctrl.ran_param_struct_t())
        ratio_group.ran_param_struct[0].ran_param_val.union.strct.contents.sz_ran_param_struct = 1 # Only one RRM Policy Member List
        rrm_policy_type = ctrl.seq_ran_param_t * ratio_group.ran_param_struct[0].ran_param_val.union.strct.contents.sz_ran_param_struct
        ratio_group.ran_param_struct[0].ran_param_val.union.strct.contents.ran_param_struct = rrm_policy_type()
        
        rrm_policy = ratio_group.ran_param_struct[0].ran_param_val.union.strct.contents.ran_param_struct[0]
        rrm_policy.ran_param_id = prb_quota_slice_level_ids["RRM Policy Member List"]
        rrm_policy.ran_param_val.type = ran_parameter_val_type_e.LIST_RAN_PARAMETER_VAL_TYPE
        # Inside RRM Policy: >>RRM Policy Member List
        rrm_policy_member_list = ctypes.pointer(ctrl.ran_param_list_t())
        rrm_policy_member_list.contents.sz_lst_ran_param = 1
        lst_param_type = ctrl.lst_ran_param_t * rrm_policy_member_list.contents.sz_lst_ran_param
        rrm_policy_member_list.contents.lst_ran_param = lst_param_type()
        # rrm_policy_member_list.contents.lst_ran_param[0].ran_pram_id = prb_quota_slice_level_ids["RRM Policy Member"] # -> missing same reasons as before
        
        # RRM Policy Member
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.sz_ran_param_struct = 2
        rrm_policy_member_type = ctrl.seq_ran_param_t * rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.sz_ran_param_struct
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct = rrm_policy_member_type()
       

        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[0].ran_param_id = prb_quota_slice_level_ids["PLMN Identity"]
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[0].ran_param_val.type = ran_parameter_val_type_e.ELEMENT_KEY_FLAG_FALSE_RAN_PARAMETER_VAL_TYPE
        # Filling plmn identity
        plmn_identity = ctrl.ran_parameter_value_t()
        plmn_identity.type = ran_parameter_value_e.OCTET_STRING_RAN_PARAMETER_VALUE
        plmn_identity.union.octet_str_ran = PLMN 
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[0].ran_param_val.union.flag_false = ctypes.pointer(plmn_identity)

        # Creating S-NSSAI structure
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_id = prb_quota_slice_level_ids["S-NSSAI"]
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.type = ran_parameter_val_type_e.STRUCTURE_RAN_PARAMETER_VAL_TYPE
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.strct = ctypes.pointer(ctrl.ran_param_struct_t())
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.strct.contents.sz_ran_param_struct = 2 # Two elements
        snssai_type = ctrl.seq_ran_param_t * rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.strct.contents.sz_ran_param_struct
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.strct.contents.ran_param_struct = snssai_type()

        # Filling S-NSSAI Structure
        # SST
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.strct.contents.ran_param_struct[0].ran_param_id = prb_quota_slice_level_ids["SST"]
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.strct.contents.ran_param_struct[0].ran_param_val.type = ran_parameter_val_type_e.ELEMENT_KEY_FLAG_FALSE_RAN_PARAMETER_VAL_TYPE
        sst = ctrl.ran_parameter_value_t()
        sst.type = ran_parameter_value_e.OCTET_STRING_RAN_PARAMETER_VALUE
        sst.union.octet_str_ran = sst_byte_array  
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.strct.contents.ran_param_struct[0].ran_param_val.union.flag_false = ctypes.pointer(sst)

        # SD
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.strct.contents.ran_param_struct[1].ran_param_id = prb_quota_slice_level_ids["SD"]
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.strct.contents.ran_param_struct[1].ran_param_val.type = ran_parameter_val_type_e.ELEMENT_KEY_FLAG_FALSE_RAN_PARAMETER_VAL_TYPE
        sd = ctrl.ran_parameter_value_t()
        sd.type = ran_parameter_value_e.OCTET_STRING_RAN_PARAMETER_VALUE
        sd.union.octet_str_ran = sd_byte_array
        rrm_policy_member_list.contents.lst_ran_param[0].ran_param_struct.ran_param_struct[1].ran_param_val.union.strct.contents.ran_param_struct[1].ran_param_val.union.flag_false = ctypes.pointer(sd)

        # inserting it in list element
        rrm_policy.ran_param_val.union.lst = rrm_policy_member_list

        # Second Element of the structure: >>Min PRB Policy Ratio
        ratio_group.ran_param_struct[1].ran_param_id = prb_quota_slice_level_ids["Min PRB Policy Ratio"]
        ratio_group.ran_param_struct[1].ran_param_val.type = ran_parameter_val_type_e.ELEMENT_KEY_FLAG_FALSE_RAN_PARAMETER_VAL_TYPE
        # Filling parameter
        min_prb_policy_ratio = ctrl.ran_parameter_value_t()
        min_prb_policy_ratio.type = ran_parameter_value_e.INTEGER_RAN_PARAMETER_VALUE
        min_prb_policy_ratio.union.int_ran = min_prb
        ratio_group.ran_param_struct[1].ran_param_val.union.flag_false = ctypes.pointer(min_prb_policy_ratio)
        
        # Third Element of the structure: >>Max PRB Policy Ratio
        ratio_group.ran_param_struct[2].ran_param_id = prb_quota_slice_level_ids["Max PRB Policy Ratio"]
        ratio_group.ran_param_struct[2].ran_param_val.type = ran_parameter_val_type_e.ELEMENT_KEY_FLAG_FALSE_RAN_PARAMETER_VAL_TYPE
        # Filling parameter
        max_prb_policy_ratio = ctrl.ran_parameter_value_t()
        max_prb_policy_ratio.type = ran_parameter_value_e.INTEGER_RAN_PARAMETER_VALUE
        max_prb_policy_ratio.union.int_ran = max_prb
        ratio_group.ran_param_struct[2].ran_param_val.union.flag_false = ctypes.pointer(max_prb_policy_ratio)

        # Third Element of the structure: >>Dedicated PRB Policy Ratio
        ratio_group.ran_param_struct[3].ran_param_id = prb_quota_slice_level_ids["Dedicated PRB Policy Ratio"]
        ratio_group.ran_param_struct[3].ran_param_val.type = ran_parameter_val_type_e.ELEMENT_KEY_FLAG_FALSE_RAN_PARAMETER_VAL_TYPE
        # Filling parameter
        ded_prb_policy_ratio = ctrl.ran_parameter_value_t()
        ded_prb_policy_ratio.type = ran_parameter_value_e.INTEGER_RAN_PARAMETER_VALUE
        ded_prb_policy_ratio.union.int_ran = dedicated_prb
        ratio_group.ran_param_struct[3].ran_param_val.union.flag_false = ctypes.pointer(ded_prb_policy_ratio)

        self.control_req.msg.union.frmt_1.ran_param[0].ran_param_val.union.lst = ctypes.pointer(rrm_policy_ratio_list)


    def ho_handler(self, ctrl_act: funcdef.seq_ctrl_act_2_t, sz_ran_param: ctypes.c_size_t, plmn_identity: str, nr_cell_id: str):
        """
        This method creates the handover control action.
        It fills the control request with the necessary parameters.
        """
        param_name_bytes = bytes(np.ctypeslib.as_array(ctrl_act.assoc_ran_param[0].name.buf, shape=(ctrl_act.assoc_ran_param[0].name.len,)))
        param_name = param_name_bytes.decode('utf-8')
        print("Setting Parameter: {}".format(param_name))

        PLMN = plmn_identity
        PLMN_bytes = bytes.fromhex(PLMN)

        nr_cell_id = nr_cell_id
        nr_cell_id = nr_cell_id.zfill(36) # It should be 36 bits long (TS 138 423 Section 9.2.2.7)
        nr_cell_id_int = int(nr_cell_id, 2)
        nr_cell_id_bytes = nr_cell_id_int.to_bytes(5, byteorder='big')  # 5 bytes for the NR Cell ID

        nrcgi_bytes = PLMN_bytes + nr_cell_id_bytes
        NRCGI = ByteArray()
        NRCGI.len = len(nrcgi_bytes)
        NRCGI.buf = (ctypes.c_uint8 * NRCGI.len)(*nrcgi_bytes)

        # Target Primary Cell ID
        self.control_req.msg.union.frmt_1.ran_param[0].ran_param_id = ho_ids["Target Primary Cell ID"]
        self.control_req.msg.union.frmt_1.ran_param[0].ran_param_val.type = ran_parameter_val_type_e.STRUCTURE_RAN_PARAMETER_VAL_TYPE
        self.control_req.msg.union.frmt_1.ran_param[0].ran_param_val.union.strct = ctypes.pointer(ctrl.ran_param_struct_t())
        target_primary_cell_strct = self.control_req.msg.union.frmt_1.ran_param[0].ran_param_val.union.strct.contents
        target_primary_cell_strct.sz_ran_param_struct = 1  # Only one element
        target_primary_cell_type = ctrl.seq_ran_param_t * target_primary_cell_strct.sz_ran_param_struct
        target_primary_cell_strct.ran_param_struct = target_primary_cell_type()

        # Filling Target Primary Cell ID: > CHOICE Target Cell
        target_primary_cell_strct.ran_param_struct[0].ran_param_id = ho_ids["CHOICE Target Cell"]
        target_primary_cell_strct.ran_param_struct[0].ran_param_val.type = ran_parameter_val_type_e.STRUCTURE_RAN_PARAMETER_VAL_TYPE
        target_primary_cell_strct.ran_param_struct[0].ran_param_val.union.strct = ctypes.pointer(ctrl.ran_param_struct_t())
        choice_target_cell_strct = target_primary_cell_strct.ran_param_struct[0].ran_param_val.union.strct.contents
        choice_target_cell_strct.sz_ran_param_struct = 1 # Two elements but filling only one
        choice_target_cell_type = ctrl.seq_ran_param_t * choice_target_cell_strct.sz_ran_param_struct
        choice_target_cell_strct.ran_param_struct = choice_target_cell_type()

        # Filling CHOICE Target Cell: >> NR Cell
        choice_target_cell_strct.ran_param_struct[0].ran_param_id = ho_ids["NR Cell"]
        choice_target_cell_strct.ran_param_struct[0].ran_param_val.type = ran_parameter_val_type_e.STRUCTURE_RAN_PARAMETER_VAL_TYPE
        choice_target_cell_strct.ran_param_struct[0].ran_param_val.union.strct = ctypes.pointer(ctrl.ran_param_struct_t())
        nr_cell_strct = choice_target_cell_strct.ran_param_struct[0].ran_param_val.union.strct.contents
        nr_cell_strct.sz_ran_param_struct = 1
        nr_cell_type = ctrl.seq_ran_param_t * nr_cell_strct.sz_ran_param_struct
        nr_cell_strct.ran_param_struct = nr_cell_type()

        # Filling NR Cell: >>> NR CGI
        nr_cell_strct.ran_param_struct[0].ran_param_id = ho_ids["NR CGI"]
        nr_cell_strct.ran_param_struct[0].ran_param_val.type = ran_parameter_val_type_e.ELEMENT_KEY_FLAG_FALSE_RAN_PARAMETER_VAL_TYPE
        # Filling NR CGI
        nrcgi_value = ctrl.ran_parameter_value_t()
        nrcgi_value.type = ran_parameter_value_e.OCTET_STRING_RAN_PARAMETER_VALUE
        nrcgi_value.union.octet_str_ran = NRCGI
        nr_cell_strct.ran_param_struct[0].ran_param_val.union.flag_false = ctypes.pointer(nrcgi_value)


    def generate_radio_bearer_control_msg(self,  style: funcdef.seq_ctrl_style_t, ue_id: hdr.ue_id_e2sm_t=None, drb_id: int=1, qos_flow_id: int=10, qos_flow_mapping_indication: int=1):
        print("Generating Radio Bearer Control Message")
        
        self.control_req.hdr = hdr.RCControlHdr()
        self.control_req.msg = ctrl.RCControlMsg()

        style_bytes = bytes(np.ctypeslib.as_array(style.name.buf, shape = (style.name.len,)))
        style_decoded = style_bytes.decode('utf-8')

        self.control_req.hdr.format = style.hdr
        
        if self.control_req.hdr.format.value != e2sm_rc_ctrl_hdr_e.FORMAT_1_E2SM_RC_CTRL_HDR:
            print("Not supported header format")
            return
        self.control_req.hdr.union.frmt_1 = hdr.e2sm_rc_ctrl_hdr_frmt_1_t()

        style_type_value = getattr(style, "style_type", 0)
        if style_type_value:
            self.control_req.hdr.union.frmt_1.ric_style_type = style_type_value
        else:
            fallback = ric_style_types.get(style_decoded, 0)
            if self.logger:
                self.logger.warning("[RCControlReqWrapper] Missing style_type in RAN function, falling back to map value {} for style '{}'".format(
                    fallback, style_decoded))
            self.control_req.hdr.union.frmt_1.ric_style_type = fallback

        # TODO How do we get ue_id?
        if not ue_id is None:
            self.control_req.hdr.union.frmt_1.ue_id = ue_id
        else:
            print("UE ID not provided skipping (this could generate an error during encoding)...")



        self.control_req.msg.format = style.msg
        if self.control_req.msg.format.value !=e2sm_rc_ctrl_msg_e.FORMAT_1_E2SM_RC_CTRL_MSG:
            print("Not supported message format")
            return
        
        seq_ctrl_act = style.seq_ctrl_act
        sz_seq_ctrl_act = style.sz_seq_ctrl_act

        if not seq_ctrl_act:
            # TODO add error message
            return
        index_supported = -1
        for j in range(0, sz_seq_ctrl_act):

            seq_ctrl_act_name_bytes = bytes(np.ctypeslib.as_array(seq_ctrl_act[j].name.buf, shape = (seq_ctrl_act[j].name.len,)))
            seq_ctrl_act_name = seq_ctrl_act_name_bytes.decode('utf-8')
            # We should make this as a parameter
            # QoS flow Mapping configuration:
            # To request the multiplexing of QoS flows to a DRB (addition, modification, deletion)
            if seq_ctrl_act_name == "QoS flow mapping configuration":
                index_supported = j
                break
        
        if index_supported == -1:
            print("No supported control action found in the style")
            return


        self.control_req.hdr.union.frmt_1.ctrl_act_id = control_action_ids_1["QoS flow mapping configuration"]

        self.control_req.msg.union.frmt_1.sz_ran_param = seq_ctrl_act[index_supported].sz_seq_assoc_ran_param
        # self.control_req.msg.union.frmt_1.sz_ran_param = 1

        # Creating ran parameter array
        RanParamArr = ctrl.seq_ran_param_t * self.control_req.msg.union.frmt_1.sz_ran_param
        self.control_req.msg.union.frmt_1.ran_param = RanParamArr()

        self.qos_flow_mapping_config_handler(seq_ctrl_act[index_supported], seq_ctrl_act[index_supported].sz_seq_assoc_ran_param, drb_id=drb_id, qos_flow_id=qos_flow_id, qos_flow_mapping_indication=qos_flow_mapping_indication)

    def generate_radio_resource_allocation_control_frmt_1(self,  style: funcdef.seq_ctrl_style_t, ue_id: hdr.ue_id_e2sm_t, plmn_identity: str, sst: int, sd: int, min_prb: int, max_prb: int, dedicated_prb: int):
        """
        radio reasource allocation format 1 control for each ue, meaning prb allocation for each ue
        """
        print("Generating Radio Resource Allocation Control Message")
        self.control_req.hdr = hdr.RCControlHdr()
        self.control_req.msg = ctrl.RCControlMsg()

        style_bytes = bytes(np.ctypeslib.as_array(style.name.buf, shape = (style.name.len,)))
        style_decoded = style_bytes.decode('utf-8')

        self.control_req.hdr.format = e2sm_rc_ctrl_hdr_e.FORMAT_1_E2SM_RC_CTRL_HDR

        self.control_req.hdr.union.frmt_1 = hdr.e2sm_rc_ctrl_hdr_frmt_1_t()

        # Radio resource allocation control
        style_type_value = getattr(style, "style_type", 0)
        if style_type_value:
            self.control_req.hdr.union.frmt_1.ric_style_type = style_type_value
        else:
            fallback = ric_style_types.get(style_decoded, 0)
            if self.logger:
                self.logger.warning("[RCControlReqWrapper] Missing style_type in RAN function, falling back to map value {} for style '{}'".format(
                    fallback, style_decoded))
            self.control_req.hdr.union.frmt_1.ric_style_type = fallback

        if ue_id is None:
            print("UE ID not provided")
            return
        
        self.control_req.hdr.union.frmt_1.ue_id = ue_id

        self.control_req.msg.format = e2sm_rc_ctrl_msg_e.FORMAT_1_E2SM_RC_CTRL_MSG

        seq_ctrl_act = style.seq_ctrl_act
        sz_seq_ctrl_act = style.sz_seq_ctrl_act

        if not seq_ctrl_act:
            # TODO add error message
            return

        index_supported = -1
        for j in range(0, sz_seq_ctrl_act):

            seq_ctrl_act_name_bytes = bytes(np.ctypeslib.as_array(seq_ctrl_act[j].name.buf, shape = (seq_ctrl_act[j].name.len,)))
            seq_ctrl_act_name = seq_ctrl_act_name_bytes.decode('utf-8')
            # Slice-level PRB quota:
            # To request the allocation of PRBs for a specific slice
            if seq_ctrl_act_name == "Slice-level PRB quota":
                index_supported = j
                break
        
        if index_supported == -1:
            print("No supported control action found in the style")
            return
        
        self.control_req.hdr.union.frmt_1.ctrl_act_id = control_action_ids_2["Slice-level PRB quota"]
        self.control_req.msg.union.frmt_1.sz_ran_param = 1

        # Creating ran parameter array
        RanParamArr = ctrl.seq_ran_param_t * self.control_req.msg.union.frmt_1.sz_ran_param
        self.control_req.msg.union.frmt_1.ran_param = RanParamArr()

        self.rrm_prb_policy_ratio_handler(seq_ctrl_act[index_supported], seq_ctrl_act[index_supported].sz_seq_assoc_ran_param, plmn_identity, sst, sd, min_prb, max_prb, dedicated_prb)

    def generate_connected_mode_mobility_control_frmt_1(self, style: funcdef.seq_ctrl_style_t, ue_id: hdr.ue_id_e2sm_t=None, plmn_identity: str=None, nr_cell_id: str=None):
        """ This method generates the Connected mode mobility control message in format 1."""
        print("Generating Connected mode mobility control format 1")
        self.control_req.hdr = hdr.RCControlHdr()
        self.control_req.msg = ctrl.RCControlMsg()

        style_bytes = bytes(np.ctypeslib.as_array(style.name.buf, shape = (style.name.len,)))
        style_decoded = style_bytes.decode('utf-8')

        self.control_req.hdr.format = e2sm_rc_ctrl_hdr_e.FORMAT_1_E2SM_RC_CTRL_HDR
        self.control_req.hdr.union.frmt_1 = hdr.e2sm_rc_ctrl_hdr_frmt_1_t()
        style_type_value = getattr(style, "style_type", 0)
        if style_type_value:
            self.control_req.hdr.union.frmt_1.ric_style_type = style_type_value
        else:
            fallback = ric_style_types.get(style_decoded, 0)
            if self.logger:
                self.logger.warning("[RCControlReqWrapper] Missing style_type in RAN function, falling back to map value {} for style '{}'".format(
                    fallback, style_decoded))
            self.control_req.hdr.union.frmt_1.ric_style_type = fallback
        if ue_id is None:
            print("UE ID not provided")
            return
        self.control_req.hdr.union.frmt_1.ue_id = ue_id # we need more information about the UE ID type, as it is not always the same

        self.control_req.msg.format = e2sm_rc_ctrl_msg_e.FORMAT_1_E2SM_RC_CTRL_MSG

        seq_ctrl_act = style.seq_ctrl_act
        sz_seq_ctrl_act = style.sz_seq_ctrl_act
        if not seq_ctrl_act:
            # TODO add error message
            return

        index_supported = -1
        for j in range(0, sz_seq_ctrl_act):

            seq_ctrl_act_name_bytes = bytes(np.ctypeslib.as_array(seq_ctrl_act[j].name.buf, shape = (seq_ctrl_act[j].name.len,)))
            seq_ctrl_act_name = seq_ctrl_act_name_bytes.decode('utf-8')
            # Slice-level PRB quota:
            # To request the allocation of PRBs for a specific slice
            if seq_ctrl_act_name == "Handover Control":
                index_supported = j
                break
        
        if index_supported == -1:
            print("No supported control action found in the style")
            return
        ctrl_act = seq_ctrl_act[index_supported]
        ctrl_act_id = getattr(ctrl_act, "ctrl_act_id", None) or control_action_ids_3.get("Handover Control", 1)
        if self.logger:
            self.logger.info("[RCControlReqWrapper] Setting Connected mode ctrl_act_id={}".format(ctrl_act_id))
        else:
            print("[RCControlReqWrapper] Setting Connected mode ctrl_act_id={}".format(ctrl_act_id))
        self.control_req.hdr.union.frmt_1.ctrl_act_id = ctrl_act_id
        self.control_req.msg.union.frmt_1.sz_ran_param = 1 # JUST Target Cell Id supported  #seq_ctrl_act[j].sz_seq_assoc_ran_param
        
        RanParamArr = ctrl.seq_ran_param_t * self.control_req.msg.union.frmt_1.sz_ran_param
        self.control_req.msg.union.frmt_1.ran_param = RanParamArr()
        self.ho_handler(seq_ctrl_act[index_supported], seq_ctrl_act[index_supported].sz_seq_assoc_ran_param, plmn_identity=plmn_identity, nr_cell_id=nr_cell_id)


        
    
    def generate_control_request(self, style, ue_id: hdr.ue_id_e2sm_t=None, ctrl_style_id: int=1):
        """
        This method generates a control request based on the style selected.
        It fills the control request with the appropriate parameters and encodes it.
        """
        # Only Radio Bearer Control Supported
        style_bytes = bytes(np.ctypeslib.as_array(style.name.buf, shape = (style.name.len,)))
        style_decoded_string = style_bytes.decode('utf-8')
        print("[RCControlReqWrapper] generate_control_request style={} ctrl_style_id={}".format(style_decoded_string, ctrl_style_id))
        if ctrl_style_id == ric_style_types["Radio Bearer Control"] and style_decoded_string == "Radio Bearer Control":
            self.generate_radio_bearer_control_msg(style=style, ue_id=ue_id)
        elif ctrl_style_id == ric_style_types["Radio Resource Allocation Control"] and style_decoded_string == "Radio Resource Allocation Control":
            self.generate_radio_resource_allocation_control_frmt_1(style=style, ue_id=ue_id)
        elif ctrl_style_id == ric_style_types["Connected mode mobility control"] and style_decoded_string == "Connected mode mobility control":
            self.generate_connected_mode_mobility_control_frmt_1(style=style, ue_id=ue_id)
        


        
    def gen_rc_msg(self, ran_func_dsc: funcdef.RCFuncDef, ue_id: hdr.ue_id_e2sm_t=None, ctrl_style_id: int=1):
        # FIXME Add other parameters
        if not ran_func_dsc.ctrl:
            # TODO Add error message
            return
        # self.control_req = RCControlReq()
        ctrl_descr = ran_func_dsc.ctrl.contents 

        self.control_req.hdr = hdr.RCControlHdr()
        self.control_req.msg = ctrl.RCControlMsg()

        for i in range(0, ctrl_descr.sz_seq_ctrl_style):
            style = ctrl_descr.seq_ctrl_style[i]
            self.generate_control_request(style, ue_id=ue_id, ctrl_style_id=ctrl_style_id)
        
    # def initialize_control_request(self):
    #     """
    #     This method initializes the control request structure.
    #     It should be called before generating the control request.
    #     """
    #     self.control_req.hdr = hdr.RCControlHdr()
    #     self.control_req.msg = ctrl.RCControlMsg()


    # def __del__(self):
        # print("tempting free")
        # if self.control_req.hdr:
        #     print("tempting freeing header")
        #     self.free_hdr(self.control_req.hdr)
        # if self.control_req.msg:
        #     print("tempting freeing msg")
        #     self.free_msg(self.control_req.msg)
    
