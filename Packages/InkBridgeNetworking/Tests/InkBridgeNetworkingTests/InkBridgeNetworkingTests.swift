import Testing
@testable import InkBridgeNetworking
import InkBridgeProtocol

@Test func localBridgeSendsEventsToHandler() {
    var receivedEvents: [RemoteInputEvent] = []

    let bridge = LocalRemoteInputBridge { event in
        receivedEvents.append(event)
    }

    bridge.send(.undo)
    bridge.send(.redo)

    #expect(receivedEvents == [.undo, .redo])
}