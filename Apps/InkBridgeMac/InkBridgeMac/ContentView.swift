//
//  ContentView.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI
import InkBridgeProtocol

struct ContentView: View {
    @State private var isOverlayVisible = false
    @State private var overlayWindowController = OverlayWindowController()
    @State private var recentEvents: [String] = []

    var body: some View {
        MacControlPanelView(
            isOverlayVisible: isOverlayVisible,
            recentEvents: recentEvents,
            onToggleOverlay: toggleOverlay,
            onClearOverlay: {
                handleOverlayEvent(.clearCanvas)
            },
            onUndo: {
                handleOverlayEvent(.undo)
            },
            onRedo: {
                handleOverlayEvent(.redo)
            },
            onAddTestStroke: {
                for event in SampleOverlayEvents.strokeEvents() {
                    handleOverlayEvent(event)
                }
            }
        )
        .padding()
        .frame(minWidth: 320, minHeight: 180)
    }
    
    private func toggleOverlay() {
        isOverlayVisible.toggle()

        if isOverlayVisible {
            overlayWindowController.showOverlay()
        } else {
            overlayWindowController.hideOverlay()
        }
    }
    
    private func handleOverlayEvent(_ event: RemoteInputEvent) {
        overlayWindowController.handle(event)
        recordEvent(event)
    }

    private func recordEvent(_ event: RemoteInputEvent) {
        recentEvents.insert(event.displayName, at: 0)

        if recentEvents.count > 5 {
            recentEvents.removeLast()
        }
    }
}

#Preview {
    ContentView()
}
