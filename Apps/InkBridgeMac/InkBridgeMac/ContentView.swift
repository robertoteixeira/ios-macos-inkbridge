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
    @State private var isOverlayVisible = false
    @State private var overlayWindowController = OverlayWindowController()
    @State private var eventLog = RemoteInputEventLog()
    @State private var bridge: LocalRemoteInputBridge?

    var body: some View {
        MacControlPanelView(
            isOverlayVisible: isOverlayVisible,
            recentEvents: eventLog.entries,
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
                let replayer = OverlayEventReplayer(
                    events: SampleOverlayEvents.strokeEvents()
                )

                replayer.replay(into: sendToLocalBridge)
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
        eventLog = eventLog.adding(event)
    }
    
    private func sendToLocalBridge(_ event: RemoteInputEvent) {
        if bridge == nil {
            bridge = LocalRemoteInputBridge { event in
                handleOverlayEvent(event)
            }
        }

        bridge?.send(event)
    }
}

#Preview {
    ContentView()
}
