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
    @State private var selectedTool: DrawingTool = .pen
    @State private var selectedColorHex = "#000000"
    @State private var strokeWidth = 4.0
    @FocusState private var isRemoteHostFocused: Bool
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            DrawingCanvasView(
                completedStrokes: $completedStrokes,
                strokeStyle: StrokeStyle(
                    colorHex: selectedColorHex,
                    width: selectedStrokeWidth,
                    opacity: selectedStrokeOpacity,
                    tool: selectedTool
                ),
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
                selectedTool: $selectedTool,
                selectedColorHex: $selectedColorHex,
                strokeWidth: $strokeWidth,
                connectionStatus: session.connectionState.displayName,
                isRemoteHostFocused: $isRemoteHostFocused,
                canConnect: canConnectToRemoteHost,
                canDisconnect: session.connectionState != .disconnected,
                onConnect: connectToRemoteHost,
                onDisconnect: session.disconnect,
                discoveredServices: session.discoveredServices.map { service in
                    DiscoveredRemoteInputServiceItem(
                        id: service.id,
                        name: service.name
                    )
                },
                onConnectToDiscoveredService: connectToDiscoveredService,
                browserStatus: session.browserState.displayName,
                emptyDiscoveryMessage: discoveryMessage
            )
            .padding()
        }
        .onAppear {
            session.startBrowsingForRemoteInputs()
        }
        .onDisappear {
            cleanupRemoteSession()
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                session.startBrowsingForRemoteInputs()
            case .background:
                cleanupRemoteSession()
            case .inactive:
                break
            @unknown default:
                break
            }
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
    
    private var discoveryMessage: String {
        switch session.browserState {
        case .connecting:
            return "Searching for Macs..."
        case .connected:
            return "No Macs found"
        case .failed(let message):
            return message
        case .disconnected:
            return "Discovery stopped"
        }
    }
    
    private var selectedStrokeWidth: Double {
        switch selectedTool {
        case .marker:
            return strokeWidth * 1.8
        case .highlighter:
            return strokeWidth * 2.4
        case .pen, .eraser, .laserPointer:
            return strokeWidth
        }
    }

    private var selectedStrokeOpacity: Double {
        switch selectedTool {
        case .highlighter:
            return 0.35
        case .pen, .marker, .eraser, .laserPointer:
            return 1.0
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

    private func connectToDiscoveredService(_ item: DiscoveredRemoteInputServiceItem) {
        guard let service = session.discoveredServices.first(where: { $0.id == item.id }) else {
            return
        }

        isRemoteHostFocused = false
        session.connect(to: service)
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
    
    private func cleanupRemoteSession() {
        session.stopBrowsingForRemoteInputs()
        session.disconnect()
    }
}

#Preview {
    ContentView()
}
