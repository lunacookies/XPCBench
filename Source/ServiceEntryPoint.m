@import Foundation;
@import XPC;

static void connectionHandler(xpc_connection_t connection) {
	xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
		if (xpc_get_type(event) == XPC_TYPE_DICTIONARY) {
			xpc_object_t reply = xpc_dictionary_create_reply(event);
			xpc_connection_send_message(connection, reply);
		}
	});
	xpc_connection_activate(connection);
}

int main(void) {
	xpc_main(connectionHandler);
}
