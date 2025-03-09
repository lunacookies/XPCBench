@import Foundation;
@import QuartzCore;
@import XPC;

int main(void) {
	xpc_connection_t connection = xpc_connection_create("org.xoria.XPCBench.Service", dispatch_get_main_queue());
	xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
		(void)event;
	});
	xpc_connection_resume(connection);

	CFTimeInterval before = CACurrentMediaTime();

	NSInteger iterationCount = 1000 * 1000;
	for (NSInteger i = 0; i < iterationCount; i++) {
		xpc_object_t message = xpc_dictionary_create_empty();
		(void)xpc_connection_send_message_with_reply_sync(connection, message);
	}

	CFTimeInterval after = CACurrentMediaTime();
	CFTimeInterval elapsed = after - before;
	NSLog(@"took %.2f µs per call", 1000 * 1000 * elapsed / (CFTimeInterval)iterationCount);

	dispatch_main();
}
