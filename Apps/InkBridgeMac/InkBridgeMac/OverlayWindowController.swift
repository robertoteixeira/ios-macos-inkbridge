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
        Canvas { context, _ in
            for stroke in viewModel.strokes {
                draw(stroke, in: context)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
    
    private func draw(_ stroke: OverlayStroke, in context: GraphicsContext) {
        guard let firstPoint = stroke.points.first else {
            return
        }
        
        var path = Path()
        path.move(to: firstPoint)
        
        for point in stroke.points.dropFirst() {
            path.addLine(to: point)
        }
        
        context.stroke(
            path,
            with: .color(.red.opacity(stroke.style.opacity)),
            lineWidth: stroke.style.width
        )
    }
}
