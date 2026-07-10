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
            with: .color(.red.opacity(stroke.style.opacity)),
            lineWidth: stroke.style.width
        )
    }
}
