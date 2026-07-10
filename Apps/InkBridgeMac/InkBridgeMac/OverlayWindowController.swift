//
//  OverlayWindowController.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 10/07/2026.
//

import AppKit
import SwiftUI

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
    var body: some View {
        ZStack {
            Color.clear
            
            Text("Overlay")
                .font(.largeTitle)
                .foregroundStyle(.red)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
