import Testing
@testable import InkBridgeRendering

@Test func normalizedPointMapsToCanvasSize() {
    let canvasSize = CanvasSize(width: 400, height: 200)

    let point = CoordinateMapper.mapNormalizedPoint(
        x: 0.5,
        y: 0.25,
        to: canvasSize
    )

    #expect(point == CanvasPoint(x: 200, y: 50))
}

@Test func normalizedCoordinateClampsIntoUnitRange() {
    #expect(NormalizedCoordinate.clamped(-0.25) == 0)
    #expect(NormalizedCoordinate.clamped(0.5) == 0.5)
    #expect(NormalizedCoordinate.clamped(1.25) == 1)
}

@Test func hexColorParserParsesSixDigitRGB() {
    let color = HexColorParser.parse("#00AAFF")

    #expect(color == RGBColor(
        red: 0,
        green: 170.0 / 255.0,
        blue: 1
    ))
}

@Test func hexColorParserRejectsInvalidHex() {
    #expect(HexColorParser.parse("not-a-color") == nil)
    #expect(HexColorParser.parse("#FFF") == nil)
}