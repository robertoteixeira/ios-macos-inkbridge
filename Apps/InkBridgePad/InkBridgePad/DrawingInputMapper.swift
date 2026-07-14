//
//  DrawingInputMapper.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 11/07/2026.
//

import CoreGraphics
import Foundation
import InkBridgeProtocol
import InkBridgeRendering

enum DrawingInputMapper {
    static func normalizedPoint(
        from location: CGPoint,
        in size: CGSize,
        pressure: Double = 1.0,
        timestamp: TimeInterval = Date().timeIntervalSince1970
    ) -> StrokePoint {
        guard size.width > 0, size.height > 0 else {
            return StrokePoint(
                x: 0,
                y: 0,
                pressure: pressure,
                timestamp: timestamp
            )
        }

        return StrokePoint(
            x: NormalizedCoordinate.clamped(location.x / size.width),
            y: NormalizedCoordinate.clamped(location.y / size.height),
            pressure: pressure,
            timestamp: timestamp
        )
    }
}
