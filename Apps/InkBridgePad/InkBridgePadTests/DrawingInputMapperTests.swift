//
//  DrawingInputMapperTests.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 11/07/2026.
//

import CoreGraphics
import Testing
@testable import InkBridgePad
import InkBridgeProtocol

@Test func normalizedPointMapsLocationIntoUnitSpace() {
    let point = DrawingInputMapper.normalizedPoint(
        from: CGPoint(x: 200, y: 50),
        in: CGSize(width: 400, height: 200),
        pressure: 0.75,
        timestamp: 123
    )

    #expect(point.x == 0.5)
    #expect(point.y == 0.25)
    #expect(point.pressure == 0.75)
    #expect(point.timestamp == 123)
}

@Test func normalizedPointHandlesZeroCanvasSize() {
    let point = DrawingInputMapper.normalizedPoint(
        from: CGPoint(x: 200, y: 50),
        in: .zero,
        pressure: 0.5,
        timestamp: 456
    )

    #expect(point.x == 0)
    #expect(point.y == 0)
    #expect(point.pressure == 0.5)
    #expect(point.timestamp == 456)
}

@Test func normalizedPointClampsLocationIntoUnitSpace() {
    let point = DrawingInputMapper.normalizedPoint(
        from: CGPoint(x: 500, y: -50),
        in: CGSize(width: 400, height: 200),
        pressure: 1.0,
        timestamp: 789
    )

    #expect(point.x == 1)
    #expect(point.y == 0)
}
