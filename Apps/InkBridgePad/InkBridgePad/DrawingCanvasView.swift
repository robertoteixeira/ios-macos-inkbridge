//
//  DrawingCanvasView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 07/07/2026.
//

import SwiftUI

struct DrawingCanvasView: View {
    @State private var completedStrokes: [[CGPoint]] = []
    @State private var currentStroke: [CGPoint] = []
    
    var body: some View {
        Canvas { context, _ in
            for stroke in completedStrokes {
                draw(stroke, in: context)
            }
            draw(currentStroke, in: context)
        }
        .background(.white)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    currentStroke.append(value.location)
                }
                .onEnded { _ in
                    completedStrokes.append(currentStroke)
                    currentStroke = []
                }
        )
    }
    
    private func draw(_ stroke: [CGPoint], in context: GraphicsContext) {
        guard let firstPoint = stroke.first else {
            return
        }
        
        var path = Path()
        path.move(to: firstPoint)
        
        for point in stroke.dropFirst() {
            path.addLine(to: point)
        }
        
        context.stroke(
            path,
            with: .color(.black),
            lineWidth: 4
        )
    }
}

#Preview {
    DrawingCanvasView()
}
