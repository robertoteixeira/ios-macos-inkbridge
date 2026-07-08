//
//  ContentView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI
import InkBridgeProtocol

struct ContentView: View {
    @State private var canvasResetID = UUID()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            DrawingCanvasView()
                .id(canvasResetID)
                .ignoresSafeArea()
            
            Button {
                print(RemoteInputEvent.clearCanvas)
                canvasResetID = UUID()
            } label: {
                Label("Clear", systemImage: "trash")
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
