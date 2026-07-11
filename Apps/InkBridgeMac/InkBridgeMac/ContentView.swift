//
//  ContentView.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var isOverlayVisible = false
    @State private var overlayWindowController = OverlayWindowController()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("InkBridge Mac")
                .font(.title)

            Text(isOverlayVisible ? "Overlay visible" : "Overlay hidden")
                .foregroundStyle(.secondary)

            Button {
                isOverlayVisible.toggle()
                
                if isOverlayVisible {
                    overlayWindowController.showOverlay()
                } else {
                    overlayWindowController.hideOverlay()
                }
            } label: {
                Label(
                    isOverlayVisible ? "Hide Overlay" : "Show Overlay",
                    systemImage: isOverlayVisible ? "eye.slash" : "eye"
                )
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                overlayWindowController.clearOverlay()
            } label: {
                Label("Clear Overlay", systemImage: "trash")
            }
            .disabled(!isOverlayVisible)
            
            Button {
                overlayWindowController.addSampleStroke()
            } label: {
                Label("Add Test Stroke", systemImage: "scribble")
            }
            .disabled(!isOverlayVisible)
        }
        .padding()
        .frame(minWidth: 320, minHeight: 180)
    }
}

#Preview {
    ContentView()
}
