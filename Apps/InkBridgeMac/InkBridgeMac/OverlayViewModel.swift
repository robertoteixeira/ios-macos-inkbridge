//
//  OverlayViewModel.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 10/07/2026.
//

import CoreGraphics
import Foundation
import InkBridgeProtocol

@Observable
final class OverlayViewModel {
    var strokes: [OverlayStroke] = [
        OverlayStroke(
            points: [
                CGPoint(x: 200, y: 200),
                CGPoint(x: 260, y: 180),
                CGPoint(x: 340, y: 220),
                CGPoint(x: 420, y: 160),
                CGPoint(x: 520, y: 240)
            ],
            style: InkBridgeProtocol.StrokeStyle(
                colorHex: "#FF0000",
                width: 8,
                opacity: 1.0,
                tool: .pen
            )
        )
    ]
    
    func clear() {
        strokes = []
    }
}
