import Foundation
import Testing
@testable import InkBridgeNetworking
import InkBridgeProtocol

private final class CapturingByteTransport: RemoteInputByteTransport {
    private(set) var sentData: [Data] = []

    func send(_ data: Data) {
        sentData.append(data)
    }
}

private final class FakeRemoteInputConnection: RemoteInputConnection {
    private(set) var state: RemoteInputConnectionState = .disconnected
    private(set) var sentData: [Data] = []

    func start() {
        state = .connected
    }

    func stop() {
        state = .disconnected
    }

    func send(_ data: Data) {
        sentData.append(data)
    }
}

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

@Test func remoteInputEventCodecRoundTripsControlEvent() throws {
    let event = RemoteInputEvent.undo

    let data = try RemoteInputEventCodec.encode(event)
    let decoded = try RemoteInputEventCodec.decode(data)

    #expect(decoded == event)
}

@Test func remoteInputEventCodecRoundTripsStrokeEvent() throws {
    let point = StrokePoint(
        x: 0.25,
        y: 0.75,
        pressure: 0.8,
        timestamp: 123
    )

    let style = StrokeStyle(
        colorHex: "#00AAFF",
        width: 6,
        opacity: 0.7,
        tool: .marker
    )

    let event = RemoteInputEvent.strokeBegan(point, style)

    let data = try RemoteInputEventCodec.encode(event)
    let decoded = try RemoteInputEventCodec.decode(data)

    #expect(decoded == event)
}

@Test func messageFrameRoundTripsPayload() {
    let payload = Data([1, 2, 3, 4])

    let frame = RemoteInputMessageFrame.encode(payload)
    let decoded = RemoteInputMessageFrame.decode(frame)

    #expect(decoded == payload)
}

@Test func messageFrameReturnsNilForIncompleteHeader() {
    let frame = Data([0, 0])

    #expect(RemoteInputMessageFrame.decode(frame) == nil)
}

@Test func messageFrameReturnsNilForIncompletePayload() {
    let frame = Data([0, 0, 0, 4, 1, 2])

    #expect(RemoteInputMessageFrame.decode(frame) == nil)
}

@Test func messageFrameDecoderWaitsForCompleteFrame() {
    let payload = Data([1, 2, 3, 4])
    let frame = RemoteInputMessageFrame.encode(payload)

    var decoder = RemoteInputMessageFrameDecoder()

    #expect(decoder.append(frame.prefix(2)) == [])
    #expect(decoder.append(frame.dropFirst(2)) == [payload])
}

@Test func messageFrameDecoderReadsMultipleFrames() {
    let firstPayload = Data([1])
    let secondPayload = Data([2, 3])

    var data = Data()
    data.append(RemoteInputMessageFrame.encode(firstPayload))
    data.append(RemoteInputMessageFrame.encode(secondPayload))

    var decoder = RemoteInputMessageFrameDecoder()

    #expect(decoder.append(data) == [firstPayload, secondPayload])
}

@Test func remoteInputEventMessageCodecRoundTripsEvent() throws {
    let event = RemoteInputEvent.redo

    let frame = try RemoteInputEventMessageCodec.encode(event)
    let decoded = try RemoteInputEventMessageCodec.decode(frame)

    #expect(decoded == event)
}

@Test func remoteInputEventMessageCodecReturnsNilForIncompleteFrame() throws {
    let frame = Data([0, 0])

    let decoded = try RemoteInputEventMessageCodec.decode(frame)

    #expect(decoded == nil)
}

@Test func remoteInputEventStreamDecoderWaitsForCompleteEventFrame() throws {
    let event = RemoteInputEvent.undo
    let frame = try RemoteInputEventMessageCodec.encode(event)

    var decoder = RemoteInputEventStreamDecoder()

    #expect(try decoder.append(frame.prefix(2)) == [])
    #expect(try decoder.append(frame.dropFirst(2)) == [event])
}

@Test func remoteInputEventStreamDecoderReadsMultipleEvents() throws {
    let firstFrame = try RemoteInputEventMessageCodec.encode(.undo)
    let secondFrame = try RemoteInputEventMessageCodec.encode(.redo)

    var data = Data()
    data.append(firstFrame)
    data.append(secondFrame)

    var decoder = RemoteInputEventStreamDecoder()

    #expect(try decoder.append(data) == [.undo, .redo])
}

@Test func byteTransportCapturesSentData() {
    let transport = CapturingByteTransport()
    let data = Data([1, 2, 3])

    transport.send(data)

    #expect(transport.sentData == [data])
}

@Test func framedRemoteInputTransportSendsEncodedEventFrame() throws {
    let byteTransport = CapturingByteTransport()
    let transport = FramedRemoteInputTransport(byteTransport: byteTransport)

    transport.send(.undo)

    #expect(byteTransport.sentData.count == 1)

    let decoded = try RemoteInputEventMessageCodec.decode(byteTransport.sentData[0])
    #expect(decoded == .undo)
}

@Test func remoteInputEventReceiverWaitsForCompleteFrame() throws {
    var receivedEvents: [RemoteInputEvent] = []
    let receiver = RemoteInputEventReceiver { event in
        receivedEvents.append(event)
    }

    let frame = try RemoteInputEventMessageCodec.encode(.undo)

    try receiver.receive(frame.prefix(2))
    #expect(receivedEvents == [])

    try receiver.receive(frame.dropFirst(2))
    #expect(receivedEvents == [.undo])
}

@Test func remoteInputEventReceiverDeliversMultipleEvents() throws {
    var data = Data()
    data.append(try RemoteInputEventMessageCodec.encode(.undo))
    data.append(try RemoteInputEventMessageCodec.encode(.redo))

    var receivedEvents: [RemoteInputEvent] = []
    let receiver = RemoteInputEventReceiver { event in
        receivedEvents.append(event)
    }

    try receiver.receive(data)

    #expect(receivedEvents == [.undo, .redo])
}

@Test func connectionStateSupportsEquality() {
    #expect(RemoteInputConnectionState.disconnected == .disconnected)
    #expect(RemoteInputConnectionState.connecting == .connecting)
    #expect(RemoteInputConnectionState.connected == .connected)
    #expect(RemoteInputConnectionState.failed("Boom") == .failed("Boom"))
    #expect(RemoteInputConnectionState.failed("Boom") != .failed("Nope"))
}

@Test func remoteInputConnectionTracksLifecycleAndSentData() {
    let connection = FakeRemoteInputConnection()
    let data = Data([1, 2, 3])

    #expect(connection.state == .disconnected)

    connection.start()
    #expect(connection.state == .connected)

    connection.send(data)
    #expect(connection.sentData == [data])

    connection.stop()
    #expect(connection.state == .disconnected)
}

@Test func remoteInputConnectionCanBeUsedAsByteTransport() {
    let connection = FakeRemoteInputConnection()
    let byteTransport: RemoteInputByteTransport = connection
    let data = Data([4, 5, 6])

    byteTransport.send(data)

    #expect(connection.sentData == [data])
}