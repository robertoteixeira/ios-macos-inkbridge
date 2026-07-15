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
    private var undoneStrokes: [OverlayStroke] = []
    
    var strokes: [OverlayStroke] = []
    
    var activeStroke: OverlayStroke? {
        currentStroke
    }
    
    func handle(_ event: RemoteInputEvent) {
        switch event {
        case let .strokeBegan(point, style):
            undoneStrokes = []
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
            
        case .undo:
            undo()
            
        case .redo:
            redo()
            
        case .modeChanged:
            break
        }
    }
    
    func clear() {
        strokes = []
        undoneStrokes = []
        currentStroke = nil
    }
    
    func undo() {
        guard let stroke = strokes.popLast() else {
            return
        }

        undoneStrokes.append(stroke)
    }

    func redo() {
        guard let stroke = undoneStrokes.popLast() else {
            return
        }

        strokes.append(stroke)
    }
}
