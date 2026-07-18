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