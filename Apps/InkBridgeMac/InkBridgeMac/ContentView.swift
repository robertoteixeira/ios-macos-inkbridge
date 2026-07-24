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
    @State private var session: MacRemoteInputSession?

    var body: some View {
        MacControlPanelView(
            isOverlayVisible: isOverlayVisible,
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
            }
        )
        .padding()
        .frame(minWidth: 320, minHeight: 180)
    }
    
    private func toggleOverlay() {
        isOverlayVisible.toggle()

        if isOverlayVisible {
            if session == nil {
                let session = MacRemoteInputSession { event in
                    overlayWindowController.handle(event)
                }
                
                session.startListening()
                self.session = session
            }

            overlayWindowController.showOverlay()
        } else {
            overlayWindowController.hideOverlay()
        }
    }
}

#Preview {
    ContentView()
}
