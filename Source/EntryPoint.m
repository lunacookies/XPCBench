@import Foundation;
@import QuartzCore;
@import XPC;

static CFTimeInterval benchForIterations(xpc_connection_t connection, NSInteger iterationCount) {
	CFTimeInterval before = CACurrentMediaTime();

	for (NSInteger i = 0; i < iterationCount; i++) {
		xpc_object_t message = xpc_dictionary_create_empty();
		(void)xpc_connection_send_message_with_reply_sync(connection, message);
	}

	CFTimeInterval after = CACurrentMediaTime();
	CFTimeInterval elapsed = after - before;
	return elapsed / (CFTimeInterval)iterationCount;
}

int main(void) {
	xpc_connection_t connection = xpc_connection_create("org.xoria.XPCBench.Service", dispatch_get_main_queue());
	xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
		(void)event;
	});
	xpc_connection_resume(connection);

	// For some reason the first send & receive takes much longer, so we
	// pull it out of the timing loop. Maybe connection creation is lazy?
	// I’m too lazy to check, anyway.
	benchForIterations(connection, 1);
	printf("took %.2f µs per call (short)\n", 1000 * 1000 * benchForIterations(connection, 100));
	printf("took %.2f µs per call (long)\n", 1000 * 1000 * benchForIterations(connection, 1000 * 1000));
}
