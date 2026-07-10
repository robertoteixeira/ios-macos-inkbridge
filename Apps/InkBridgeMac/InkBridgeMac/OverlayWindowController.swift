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
            rootView: OverlayDebugView()
        )
        
        window.makeKeyAndOrderFront(nil)
        
        self.window = window
    }
    
    func hideOverlay() {
        window?.orderOut(nil)
    }
}

private struct OverlayDebugView: View {
    private let sampleStrokes: [OverlayStroke] = [
        OverlayStroke(
            points: [
                CGPoint(x: 200, y: 200),
                CGPoint(x: 260, y: 180),
                CGPoint(x: 340, y: 220),
                CGPoint(x: 420, y: 160),
                CGPoint(x: 520, y: 240)
            ],
            style: InkBridgeProtocol.StrokeStyle(
                colorHex: "#FF0000",
                width: 8,
                opacity: 1.0,
                tool: .pen
            )
        )
    ]
    
    var body: some View {
        Canvas { context, _ in
            for stroke in sampleStrokes {
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
