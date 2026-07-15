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
    
    func addTestStroke() {
        for event in SampleOverlayEvents.strokeEvents() {
            handle(event)
        }
    }
    
    func clear() {
        handle(.clearCanvas)
    }
    
    func undo() {
        handle(.undo)
    }

    func redo() {
        handle(.redo)
    }
}
