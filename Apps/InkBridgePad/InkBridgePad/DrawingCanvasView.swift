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
    let strokeStyle: InkBridgeProtocol.StrokeStyle
    let onRemoteInputEvent: (RemoteInputEvent) -> Void
    
    @State private var currentStroke: [CGPoint] = []
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, _ in
                for stroke in completedStrokes {
                    draw(stroke.points, style: stroke.style, in: context)
                }
                draw(currentStroke, style: currentStyle, in: context)
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
        strokeStyle
    }
    
    private func draw(
        _ stroke: [CGPoint],
        style: InkBridgeProtocol.StrokeStyle,
        in context: GraphicsContext) {
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
            with: .color(color(from: style.colorHex, opacity: style.opacity)),
            lineWidth: style.width
        )
    }
    
    private func color(from hex: String, opacity: Double) -> Color {
        switch hex {
        case "#FF3B30":
            return .red.opacity(opacity)
        case "#007AFF":
            return .blue.opacity(opacity)
        case "#FFCC00":
            return .yellow.opacity(opacity)
        default:
            return .black.opacity(opacity)
        }
    }
}

#Preview {
    DrawingCanvasView(
        completedStrokes: .constant([]),
        strokeStyle: StrokeStyle(
            colorHex: "#000000",
            width: 4,
            opacity: 1.0,
            tool: .pen
        ),
        onRemoteInputEvent: { _ in }
    )
}
