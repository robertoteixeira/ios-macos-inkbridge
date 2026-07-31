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
    @State private var session = PadRemoteInputSession()
    
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
                connectionStatus: session.connectionState.displayName
            )
            .padding()
        }
        .onAppear {
            session.connectToHost(
                RemoteInputConfiguration.host,
                port: RemoteInputConfiguration.port
            )
        }
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
