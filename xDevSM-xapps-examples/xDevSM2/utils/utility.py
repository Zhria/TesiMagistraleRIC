import ctypes
import json

def read_file(filename):
    try:
        with open(filename, 'r') as f:
            data = f.read()
            if len(data) == 0:
                return None
            return data
    except IOError as error:
        return None

def get_c_byte_array_from_py_byte_string(byte_string: bytes):
    try:
        byte_data = bytes(byte_string.decode('unicode_escape').encode('latin-1'))
        byte_array = (ctypes.c_uint8 * len(byte_data)).from_buffer_copy(byte_data)

        return byte_array
    except:
        print("exception in byte array")
        return None


def write_routing_table(app_name: str, app_namespace: str, rmr_port: int, route_path: str) -> bool:
    """
    Writes a routing table to the specified file.
    
    Args:
        app_name (str): name of xApp
        app_namespace (str): namespace of xApp
        rmr_port (int): port for RIC message routing
        route_file_path (str): path of route file to write to
    
    Returns:
        bool: True if the file was written successfully, False otherwise
    """

    xapp_port = rmr_port
    message_type_list = [12011, 12012, 12021, 12022, 12050]

    routing_table_start = "newrt|start\n"
    routing_table_end = "newrt|end"

    routing_table = routing_table_start
    for m in message_type_list:
        route = f"rte|{m}|service-{app_namespace}-{app_name}-rmr.{app_namespace}:{xapp_port}\n"
        routing_table += route
    routing_table += routing_table_end

    print(routing_table)
    
    try:
        with open(route_path, 'w') as f:
            f.write(routing_table)
        return True
    except Exception as e:
        print(f"Error writing to file: {e}")
        return False