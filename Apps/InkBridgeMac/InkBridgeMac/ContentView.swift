//
//  ContentView.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI
import InkBridgeProtocol
import InkBridgeNetworking

struct ContentView: View {
    @State private var isOverlayRunning = false
    @State private var overlayWindowController = OverlayWindowController()
    @State private var session: MacRemoteInputSession?

    var body: some View {
        MacControlPanelView(
            isOverlayVisible: isOverlayRunning,
            recentEvents: session?.eventLog.entries ?? [],
            onToggleOverlay: toggleOverlay,
            onClearOverlay: {
                session?.send(.clearCanvas)
            },
            onUndo: {
                session?.send(.undo)
            },
            onRedo: {
                session?.send(.redo)
            },
            onAddTestStroke: {
                let replayer = OverlayEventReplayer(
                    events: SampleOverlayEvents.strokeEvents()
                )

                replayer.replay { event in
                    session?.send(event)
                }
            },
            listenerStatus: session?.listenerState.displayName ?? "Disconnected",
            connectionStatus: session?.connectionState.displayName ?? "Disconnected"
        )
        .padding()
        .frame(minWidth: 320, minHeight: 180)
    }
    
    private func toggleOverlay() {
        isOverlayRunning.toggle()

        if isOverlayRunning {
            if session == nil {
                session = MacRemoteInputSession { event in
                    overlayWindowController.handle(event)
                }
            }

            session?.startListening()
            overlayWindowController.showOverlay()
        } else {
            session?.stopListening()
            overlayWindowController.hideOverlay()
        }
    }
}

#Preview {
    ContentView()
}
