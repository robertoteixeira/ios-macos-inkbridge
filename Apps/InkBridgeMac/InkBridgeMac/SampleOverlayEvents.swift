//
//  SampleOverlayEvents.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 15/07/2026.
//

import Foundation
import InkBridgeProtocol

enum SampleOverlayEvents {
    static func strokeEvents() -> [RemoteInputEvent] {
        let style = InkBridgeProtocol.StrokeStyle(
            colorHex: "#00AAFF",
            width: 8,
            opacity: 1.0,
            tool: .pen
        )

        return [
            .strokeBegan(
                StrokePoint(x: 0.20, y: 0.30, pressure: 1.0, timestamp: 0),
                style
            ),
            .strokeMoved([
                StrokePoint(x: 0.35, y: 0.25, pressure: 1.0, timestamp: 0),
                StrokePoint(x: 0.50, y: 0.38, pressure: 1.0, timestamp: 0)
            ]),
            .strokeEnded(
                StrokePoint(x: 0.70, y: 0.28, pressure: 1.0, timestamp: 0)
            )
        ]
    }
}
