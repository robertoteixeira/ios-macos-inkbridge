//
//  OverlayStroke.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 10/07/2026.
//

import CoreGraphics
import Foundation
import InkBridgeProtocol

struct OverlayStroke: Identifiable, Equatable {
    let id: UUID
    let points: [StrokePoint]
    let style: InkBridgeProtocol.StrokeStyle
    
    init(
        id: UUID = UUID(),
        points: [StrokePoint],
        style: InkBridgeProtocol.StrokeStyle
    ) {
        self.id = id
        self.points = points
        self.style = style
    }
}
