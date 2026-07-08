//
//  ContentView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI
import InkBridgeProtocol

struct ContentView: View {
    @State private var completedStrokes: [[CGPoint]] = []
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            DrawingCanvasView(completedStrokes: $completedStrokes)
                .ignoresSafeArea()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("\(completedStrokes.count) strokes")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                
                Button {
                    print(RemoteInputEvent.clearCanvas)
                    completedStrokes = []
                } label: {
                    Label("Clear", systemImage: "trash")
                }
                .buttonStyle(.borderedProminent)
            }

            .padding()
        }
    }
}

#Preview {
    ContentView()
}
