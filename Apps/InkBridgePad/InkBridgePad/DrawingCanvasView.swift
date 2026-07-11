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
    
    let onRemoteInputEvent: (RemoteInputEvent) -> Void
    
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
                        let point = DrawingInputMapper.normalizedPoint(
                            from: value.location,
                            in: geometry.size
                        )
                        
                        if currentStroke.isEmpty {
                            onRemoteInputEvent(.strokeBegan(point, currentStyle))
                        } else {
                            onRemoteInputEvent(.strokeMoved([point]))
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
                        
                        let point = DrawingInputMapper.normalizedPoint(
                            from: value.location,
                            in: geometry.size
                        )
                        
                        onRemoteInputEvent(.strokeEnded(point))

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
}

#Preview {
    DrawingCanvasView(
        completedStrokes: .constant([]),
        onRemoteInputEvent: { _ in }
    )
}
