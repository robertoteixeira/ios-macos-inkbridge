//
//  DrawingCanvasView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 07/07/2026.
//

import SwiftUI
import InkBridgeProtocol

struct DrawingCanvasView: View {
    @Binding var completedStrokes: [InkStroke]
    @State private var currentStroke: [CGPoint] = []
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, _ in
                for stroke in completedStrokes {
                    draw(stroke.points, in: context)
                }
                draw(currentStroke, in: context)
            }
            .background(.white)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = normalizedPoint(
                            from: value.location,
                            in: geometry.size
                        )
                        
                        if currentStroke.isEmpty {
                            print(RemoteInputEvent.strokeBegan(point, currentStyle))
                        } else {
                            print(RemoteInputEvent.strokeMoved([point]))
                        }
                        
                        currentStroke.append(value.location)
                    }
                    .onEnded { value in
                        completedStrokes.append(
                            InkStroke(
                                points: currentStroke,
                                style: currentStyle
                            )
                        )
                        
                        let point = normalizedPoint(
                            from: value.location,
                            in: geometry.size
                        )
                        
                        print(RemoteInputEvent.strokeEnded(point))

                        currentStroke = []
                    }
            )
        }
    }
    
    private var currentStyle: InkBridgeProtocol.StrokeStyle {
        StrokeStyle(
            colorHex: "#000000",
            width: 4,
            opacity: 1.0,
            tool: .pen
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
    DrawingCanvasView(completedStrokes: .constant([]))
}
