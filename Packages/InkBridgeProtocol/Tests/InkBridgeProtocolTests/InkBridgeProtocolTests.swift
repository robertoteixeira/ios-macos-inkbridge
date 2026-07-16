import Foundation
import Testing
@testable import InkBridgeProtocol

@Test func strokePointEncodesAndDecodes() throws {
    let point = StrokePoint(
        x: 0.25,
        y: 0.75,
        pressure: 0.8,
        timestamp: 123.456
    )

    let data = try JSONEncoder().encode(point)
    let decoded = try JSONDecoder().decode(StrokePoint.self, from: data)

    #expect(decoded == point)
}

@Test func remoteInputEventStrokeBeganRoundTrips() throws {
    let point = StrokePoint(
        x: 0.1,
        y: 0.2,
        pressure: 1.0,
        timestamp: 10
    )

    let style = StrokeStyle(
        colorHex: "#FF0000",
        width: 8,
        opacity: 0.9,
        tool: .pen
    )

    let event = RemoteInputEvent.strokeBegan(point, style)

    let data = try JSONEncoder().encode(event)
    let decoded = try JSONDecoder().decode(RemoteInputEvent.self, from: data)

    #expect(decoded == event)
}

@Test func remoteInputEventClearCanvasRoundTrips() throws {
    let event = RemoteInputEvent.clearCanvas

    let data = try JSONEncoder().encode(event)
    let decoded = try JSONDecoder().decode(RemoteInputEvent.self, from: data)

    #expect(decoded == event)
}

@Test func remoteInputEventDisplayNamesMatchCases() {
    let point = StrokePoint(x: 0, y: 0, pressure: 1, timestamp: 0)
    let style = StrokeStyle(
        colorHex: "#000000",
        width: 1,
        opacity: 1,
        tool: .pen
    )

    #expect(RemoteInputEvent.strokeBegan(point, style).displayName == "strokeBegan")
    #expect(RemoteInputEvent.strokeMoved([point]).displayName == "strokeMoved")
    #expect(RemoteInputEvent.strokeEnded(point).displayName == "strokeEnded")
    #expect(RemoteInputEvent.clearCanvas.displayName == "clearCanvas")
    #expect(RemoteInputEvent.undo.displayName == "undo")
    #expect(RemoteInputEvent.redo.displayName == "redo")
    #expect(RemoteInputEvent.modeChanged(.overlay).displayName == "modeChanged")
}