//
//  ContentView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI
import InkBridgeProtocol
import InkBridgeNetworking

struct ContentView: View {
    @State private var completedStrokes: [InkStroke] = []
    @State private var undoneStrokes: [InkStroke] = []
    @State private var eventLog = RemoteInputEventLog()
    @State private var bridge: LocalRemoteInputBridge?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            DrawingCanvasView(
                completedStrokes: $completedStrokes,
                onRemoteInputEvent:  { event in
                    if case .strokeBegan = event {
                        undoneStrokes = []
                    }
                            
                    sendToLocalBridge(event)
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
                recentEvents: eventLog.entries
            )
            .padding()
        }
    }
    
    private func undoLastStroke() {
        guard let stroke = completedStrokes.popLast() else {
            return
        }

        undoneStrokes.append(stroke)
        sendToLocalBridge(.undo)
    }

    private func redoLastStroke() {
        guard let stroke = undoneStrokes.popLast() else {
            return
        }

        completedStrokes.append(stroke)
        sendToLocalBridge(.redo)
    }

    private func clearCanvas() {
        completedStrokes = []
        undoneStrokes = []
        sendToLocalBridge(.clearCanvas)
    }
    
    private func sendToLocalBridge(_ event: RemoteInputEvent) {
        if bridge == nil {
            bridge = LocalRemoteInputBridge { event in
                recordRemoteInputEvent(event)
            }
        }

        bridge?.send(event)
    }

    private func recordRemoteInputEvent(_ event: RemoteInputEvent) {
        print(event)
        eventLog = eventLog.adding(event)
    }
}

#Preview {
    ContentView()
}
