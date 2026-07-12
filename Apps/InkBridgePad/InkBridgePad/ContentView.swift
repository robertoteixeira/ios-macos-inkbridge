//
//  ContentView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI
import InkBridgeProtocol

struct ContentView: View {
    @State private var completedStrokes: [InkStroke] = []
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            DrawingCanvasView(
                completedStrokes: $completedStrokes,
                onRemoteInputEvent: handleRemoteInputEvent
            )
            .ignoresSafeArea()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("\(completedStrokes.count) strokes")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                
                Button {
                    completedStrokes = []
                    handleRemoteInputEvent(.clearCanvas)
                } label: {
                    Label("Clear", systemImage: "trash")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    guard !completedStrokes.isEmpty else {
                        return
                    }
                    
                    completedStrokes.removeLast()
                    handleRemoteInputEvent(.undo)
                } label: {
                    Label("Undo", systemImage: "arrow.turn.backward")
                }
                .disabled(completedStrokes.isEmpty)
            }

            .padding()
        }
    }
    
    private func handleRemoteInputEvent(_ event: RemoteInputEvent) {
        print(event)
    }
}

#Preview {
    ContentView()
}
