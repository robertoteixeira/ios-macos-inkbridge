//
//  OverlayWindowController.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 10/07/2026.
//

import AppKit
import SwiftUI
import InkBridgeProtocol

final class OverlayWindowController {
    private var window: NSWindow?
    
    let viewModel = OverlayViewModel()
    
    func showOverlay() {
        if let window {
            window.makeKeyAndOrderFront(nil)
            return
        }
        
        let screenFrame = NSScreen.main?.frame ?? .zero
        
        let window = NSWindow(
            contentRect: screenFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.ignoresMouseEvents = true
        window.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary
        ]
        
        window.contentView = NSHostingView(
            rootView: OverlayDebugView(viewModel: viewModel)
        )
        
        window.makeKeyAndOrderFront(nil)
        
        self.window = window
    }
    
    func handle(_ event: RemoteInputEvent) {
        viewModel.handle(event)
    }
    
    func hideOverlay() {
        window?.orderOut(nil)
    }
    
    func clearOverlay() {
        viewModel.clear()
    }
}

private struct OverlayDebugView: View {
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
    
    private func draw(_ stroke: OverlayStroke, in context: GraphicsContext, size: CGSize) {
        guard let firstPoint = stroke.points.first else {
            return
        }
        
        var path = Path()
        path.move(
            to: CGPoint(
                x: firstPoint.x * size.width,
                y: firstPoint.y * size.height
            )
        )

        for point in stroke.points.dropFirst() {
            path.addLine(
                to: CGPoint(
                    x: point.x * size.width,
                    y: point.y * size.height
                )
            )
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
        
        return Color(
            red: red,
            green: green,
            blue: blue,
            opacity: opacity
        )
    }
}
