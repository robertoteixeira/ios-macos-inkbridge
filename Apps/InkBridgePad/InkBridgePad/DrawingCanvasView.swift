//
//  DrawingCanvasView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 07/07/2026.
//

import SwiftUI
import InkBridgeProtocol

struct DrawingCanvasView: View {
    @State private var completedStrokes: [[CGPoint]] = []
    @State private var currentStroke: [CGPoint] = []
    
    var body: some View {
        GeometryReader { geometry in
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
                        
                        let point = normalizedPoint(
                            from: value.location,
                            in: geometry.size
                        )
                        
                        print(RemoteInputEvent.strokeMoved([point]))
                    }
                    .onEnded { value in
                        completedStrokes.append(currentStroke)
                        
                        let point = normalizedPoint(
                            from: value.location,
                            in: geometry.size
                        )
                        
                        print(RemoteInputEvent.strokeMoved([point]))

                        currentStroke = []
                    }
            )
        }
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
    
    private func normalizedPoint(from location: CGPoint, in size: CGSize) -> StrokePoint {
        StrokePoint(
            x: location.x / size.width,
            y: location.y / size.height,
            pressure: 1.0,
            timestamp: Date().timeIntervalSince1970
        )
    }
}

#Preview {
    DrawingCanvasView()
}
