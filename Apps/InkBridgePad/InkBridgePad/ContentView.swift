//
//  ContentView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI
import Foundation
import InkBridgeProtocol
import InkBridgeNetworking

struct ContentView: View {
    @State private var completedStrokes: [InkStroke] = []
    @State private var undoneStrokes: [InkStroke] = []
    @State private var session = PadRemoteInputSession()
    @State private var remoteHost = RemoteInputConfiguration.host
    @FocusState private var isRemoteHostFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            DrawingCanvasView(
                completedStrokes: $completedStrokes,
                onRemoteInputEvent:  { event in
                    if case .strokeBegan = event {
                        undoneStrokes = []
                    }
                            
                    session.send(event)
                }
            )
            .ignoresSafeArea()
            
            DrawingControlsView(
                completedStrokeCount: completedStrokes.count,
                undoneStrokeCount: undoneStrokes.count,
                canUndo: !completedStrokes.isEmpty,
                canRedo: !undoneStrokes.isEmpty,
                onUndo: undoLastStroke,
                onRedo: redoLastStroke,
                onClear: clearCanvas,
                recentEvents: session.eventLog.entries,
                remoteHost: $remoteHost,
                connectionStatus: session.connectionState.displayName,
                isRemoteHostFocused: $isRemoteHostFocused,
                canConnect: canConnectToRemoteHost,
                canDisconnect: session.connectionState != .disconnected,
                onConnect: connectToRemoteHost,
                onDisconnect: session.disconnect
            )
            .padding()
        }
    }
    
    private var canConnectToRemoteHost: Bool {
        let host = remoteHost.trimmingCharacters(in: .whitespacesAndNewlines)

        switch session.connectionState {
        case .disconnected, .failed:
            return !host.isEmpty
        case .connecting, .connected:
            return false
        }
    }

    private func connectToRemoteHost() {
        isRemoteHostFocused = false

        let host = remoteHost.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !host.isEmpty else {
            return
        }
        
        session.connectToHost(
            host,
            port: RemoteInputConfiguration.port
        )
    }
    
    private func undoLastStroke() {
        guard let stroke = completedStrokes.popLast() else {
            return
        }

        undoneStrokes.append(stroke)
        session.send(.undo)
    }

    private func redoLastStroke() {
        guard let stroke = undoneStrokes.popLast() else {
            return
        }

        completedStrokes.append(stroke)
        session.send(.redo)
    }

    private func clearCanvas() {
        completedStrokes = []
        undoneStrokes = []
        session.send(.clearCanvas)
    }
}

#Preview {
    ContentView()
}
