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
        
        let screenFrame = targetScreenFrame()

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
        
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        
        self.window = window
    }
    
    func handle(_ event: RemoteInputEvent) {
        viewModel.handle(event)
    }
    
    func hideOverlay() {
        viewModel.clear()
        window?.close()
        window = nil
    }
    
    private func targetScreenFrame() -> CGRect {
        NSScreen.main?.frame ?? NSScreen.screens.first?.frame ?? .zero
    }
}
