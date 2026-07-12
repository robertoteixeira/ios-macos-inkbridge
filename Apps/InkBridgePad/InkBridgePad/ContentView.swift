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
    @State private var undoneStrokes: [InkStroke] = []
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            DrawingCanvasView(
                completedStrokes: $completedStrokes,
                onRemoteInputEvent:  { event in
                    if case .strokeBegan = event {
                        undoneStrokes = []
                    }
                            
                    handleRemoteInputEvent(event)
                }
            )
            .ignoresSafeArea()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("\(completedStrokes.count) strokes")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                
                Text("\(undoneStrokes.count) redo")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                
                HStack(spacing: 8) {
                    Button {
                        guard let stroke = completedStrokes.popLast() else {
                            return
                        }
                        
                        undoneStrokes.append(stroke)
                        handleRemoteInputEvent(.undo)
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                    .accessibilityLabel("Undo")
                    .disabled(completedStrokes.isEmpty)
                    
                    Button {
                        guard let stroke = undoneStrokes.popLast() else {
                            return
                        }
                        
                        completedStrokes.append(stroke)
                        handleRemoteInputEvent(.redo)
                    } label: {
                        Image(systemName: "arrow.uturn.forward")
                    }
                    .accessibilityLabel("Redo")
                    .disabled(undoneStrokes.isEmpty)
                }
                
                Button {
                    completedStrokes = []
                    undoneStrokes = []
                    handleRemoteInputEvent(.clearCanvas)
                } label: {
                    Label("Clear", systemImage: "trash")
                }
                .buttonStyle(.borderedProminent)
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
