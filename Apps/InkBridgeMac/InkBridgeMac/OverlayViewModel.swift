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
    private var currentStroke: OverlayStroke?
    
    var strokes: [OverlayStroke] = [
        OverlayStroke(
            points: [
                StrokePoint(x: 0.15, y: 0.30, pressure: 1.0, timestamp: 0),
                StrokePoint(x: 0.25, y: 0.25, pressure: 1.0, timestamp: 0),
                StrokePoint(x: 0.38, y: 0.34, pressure: 1.0, timestamp: 0),
                StrokePoint(x: 0.50, y: 0.22, pressure: 1.0, timestamp: 0),
                StrokePoint(x: 0.65, y: 0.40, pressure: 1.0, timestamp: 0)
            ],
            style: InkBridgeProtocol.StrokeStyle(
                colorHex: "#FF0000",
                width: 8,
                opacity: 1.0,
                tool: .pen
            )
        )
    ]
    
    var activeStroke: OverlayStroke? {
        currentStroke
    }
    
    func handle(_ event: RemoteInputEvent) {
        switch event {
        case let .strokeBegan(point, style):
            currentStroke = OverlayStroke(
                points: [point],
                style: style
            )
            
        case let .strokeMoved(points):
            guard var stroke = currentStroke else {
                return
            }
            
            stroke = OverlayStroke(
                id: stroke.id,
                points: stroke.points + points,
                style: stroke.style
            )
            
            currentStroke = stroke
            
        case let .strokeEnded(point):
            guard let stroke = currentStroke else {
                return
            }
            
            strokes.append(
                OverlayStroke(
                    id: stroke.id,
                    points: stroke.points + [point],
                    style: stroke.style
                )
            )
            
            currentStroke = nil
            
        case .clearCanvas:
            clear()
            
        case .undo, .redo, .modeChanged:
            break
        }
    }
    
    func clear() {
        strokes = []
    }
}
