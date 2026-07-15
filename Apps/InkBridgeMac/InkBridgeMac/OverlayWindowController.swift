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
            rootView: OverlayView(viewModel: viewModel)
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
    
    func addSampleStroke() {
        let style = InkBridgeProtocol.StrokeStyle(
            colorHex: "#00AAFF",
            width: 8,
            opacity: 1.0,
            tool: .pen
        )

        handle(
            .strokeBegan(
                StrokePoint(x: 0.20, y: 0.30, pressure: 1.0, timestamp: 0),
                style
            )
        )

        handle(
            .strokeMoved([
                StrokePoint(x: 0.35, y: 0.25, pressure: 1.0, timestamp: 0),
                StrokePoint(x: 0.50, y: 0.38, pressure: 1.0, timestamp: 0)
            ])
        )

        handle(
            .strokeEnded(
                StrokePoint(x: 0.70, y: 0.28, pressure: 1.0, timestamp: 0)
            )
        )
    }
}
