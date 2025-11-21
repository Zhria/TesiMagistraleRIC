import numpy as np

from decorators.rc.rc_control_base import RCControlBase


class ConnectedModeMobilityControl(RCControlBase):
    """
    Connected Mode Mobility Control Decorator
    """

    def __init__(self, 
                 xapp_handler, 
                 logger, 
                 server, 
                 xapp_name, 
                 rmr_port,
                 mrc, 
                 http_port, 
                 pltnamespace, 
                 app_namespace,
                 # control parameters
                 plmn_identity, 
                 nr_cell_id=None):
        super().__init__(xapp_handler, logger, server, xapp_name, rmr_port, mrc, http_port, pltnamespace, app_namespace)
        self.service_style_name = "Connected mode mobility control"
        self.plmn_identity = plmn_identity
        self.nr_cell_id = nr_cell_id


    @staticmethod
    def _byte_array_to_str(byte_array):
        if not byte_array or not byte_array.buf or byte_array.len == 0:
            return ""
        np_buf = np.ctypeslib.as_array(byte_array.buf, shape=(byte_array.len,))
        return bytes(np_buf).decode("utf-8")

    def _style_supports_action(self, style, action_name):
        if not style or not style.seq_ctrl_act or style.sz_seq_ctrl_act == 0:
            return False
        advertised_actions = []
        for idx in range(style.sz_seq_ctrl_act):
            ctrl_act = style.seq_ctrl_act[idx]
            current_name = self._byte_array_to_str(ctrl_act.name)
            advertised_actions.append(current_name)
            if current_name == action_name:
                self.logger.info("[RCConnectedModeMobilityControl] Style '{}' advertises action '{}'".format(
                    self._byte_array_to_str(style.name), current_name))
                return True
        self.logger.info("[RCConnectedModeMobilityControl] Style '{}' actions available: {} (missing '{}')".format(
            self._byte_array_to_str(style.name), advertised_actions or "none", action_name))
        return False

    def _validate_preconditions(self, ue_id):
        if self.style is None:
            self.logger.error("[RCConnectedModeMobilityControl] Control style not initialized")
            return False

        decoded_name = self._byte_array_to_str(self.style.name)
        if decoded_name != self.service_style_name:
            self.logger.error("[RCConnectedModeMobilityControl] Unexpected style '{}' (expected '{}')".format(
                decoded_name, self.service_style_name))
            return False

        if ue_id is None:
            self.logger.error("[RCConnectedModeMobilityControl] Missing UE information, aborting control request")
            return False

        if not self._style_supports_action(self.style, "Handover Control"):
            self.logger.error("[RCConnectedModeMobilityControl] Style '{}' does not advertise 'Handover Control'".format(
                decoded_name))
            return False

        if not self.plmn_identity or not self.nr_cell_id:
            self.logger.error("[RCConnectedModeMobilityControl] Missing PLMN ({}) or NR Cell ID ({})".format(
                self.plmn_identity, self.nr_cell_id))
            return False

        return True
    
    def set_plmn_identity(self, plmn_identity):
        self.plmn_identity = plmn_identity
    
    def set_nr_cell_id(self, nr_cell_id):
        self.nr_cell_id = nr_cell_id

    def generate_control_request(self, ue_id, control_action_id=1):
        if not self._validate_preconditions(ue_id):
            return

        if control_action_id == 1:  # Handover Control
            self.wrapper.generate_connected_mode_mobility_control_frmt_1(self.style, 
                                                                         ue_id=ue_id, 
                                                                         plmn_identity=self.plmn_identity, 
                                                                         nr_cell_id=self.nr_cell_id)
        else:
            self.logger.error("[RCConnectedModeMobilityControl] xDevSM does not support control action ID: {}".format(control_action_id))
