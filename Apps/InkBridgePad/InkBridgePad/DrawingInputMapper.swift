//
//  DrawingInputMapper.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 11/07/2026.
//

import CoreGraphics
import Foundation
import InkBridgeProtocol

enum DrawingInputMapper {
    static func normalizedPoint(
        from location: CGPoint,
        in size: CGSize,
        pressure: Double = 1.0,
        timestamp: TimeInterval = Date().timeIntervalSince1970
    ) -> StrokePoint {
        StrokePoint(
            x: location.x / size.width,
            y: location.y / size.height,
            pressure: pressure,
            timestamp: timestamp
        )
    }
}
