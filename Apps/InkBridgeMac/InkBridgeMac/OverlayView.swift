//
//  OverlayView.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 11/07/2026.
//

import SwiftUI
import InkBridgeProtocol
import InkBridgeRendering

struct OverlayView: View {
    let viewModel: OverlayViewModel

    var body: some View {
        Canvas { context, size in
            for stroke in viewModel.strokes {
                draw(stroke, in: context, size: size)
            }

            if let activeStroke = viewModel.activeStroke {
                draw(activeStroke, in: context, size: size)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }

    private func draw(
        _ stroke: OverlayStroke,
        in context: GraphicsContext,
        size: CGSize
    ) {
        guard let firstPoint = stroke.points.first else {
            return
        }

        var path = Path()
        path.move(to: mappedPoint(firstPoint, in: size))

        for point in stroke.points.dropFirst() {
            path.addLine(to: mappedPoint(point, in: size))
        }

        context.stroke(
            path,
            with: .color(
                color(
                    from: stroke.style.colorHex,
                    opacity: stroke.style.opacity
                )
            ),
            lineWidth: stroke.style.width
        )
    }

    private func mappedPoint(_ point: StrokePoint, in size: CGSize) -> CGPoint {
        let mappedPoint = CoordinateMapper.mapNormalizedPoint(
            x: NormalizedCoordinate.clamped(point.x),
            y: NormalizedCoordinate.clamped(point.y),
            to: CanvasSize(
                width: size.width,
                height: size.height
            )
        )

        return CGPoint(
            x: mappedPoint.x,
            y: mappedPoint.y
        )
    }

    private func color(from hex: String, opacity: Double) -> Color {
        let trimmedHex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))

        guard
            trimmedHex.count == 6,
            let value = Int(trimmedHex, radix: 16)
        else {
            return .red.opacity(opacity)
        }

        let red = Double((value >> 16) & 0xFF) / 255.0
        let green = Double((value >> 8) & 0xFF) / 255.0
        let blue = Double(value & 0xFF) / 255.0

        return Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}
