import Testing
@testable import InkBridgeNetworking
import InkBridgeProtocol

@Test func localTransportSendsEventsToHandler() {
    var receivedEvents: [RemoteInputEvent] = []

    let transport = LocalRemoteInputTransport { event in
        receivedEvents.append(event)
    }

    transport.send(.undo)
    transport.send(.redo)

    #expect(receivedEvents == [.undo, .redo])
}

@Test func localTransportCanBeUsedAsRemoteInputTransport() {
    var receivedEvents: [RemoteInputEvent] = []

    let transport: RemoteInputTransport = LocalRemoteInputTransport { event in
        receivedEvents.append(event)
    }

    transport.send(.clearCanvas)

    #expect(receivedEvents == [.clearCanvas])
}