//
//  ContentView.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI
import InkBridgeProtocol

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
            
            sampleButton
        }
        .padding()
        .frame(minWidth: 320, minHeight: 180)
    }
    
    private var sampleButton: some View {
        Button {
            let style = InkBridgeProtocol.StrokeStyle(
                colorHex: "#FF0000",
                width: 8,
                opacity: 1.0,
                tool: .pen
            )
            
            overlayWindowController.handle(
                .strokeBegan(
                    StrokePoint(x: 0.20, y: 0.30, pressure: 1.0, timestamp: 0),
                    style
                )
            )
            
            overlayWindowController.handle(
                .strokeMoved([
                    StrokePoint(x: 0.35, y: 0.25, pressure: 1.0, timestamp: 0),
                    StrokePoint(x: 0.50, y: 0.38, pressure: 1.0, timestamp: 0),
                ])
            )
            
            overlayWindowController.handle(
                .strokeEnded(
                    StrokePoint(x: 0.70, y: 0.28, pressure: 1.0, timestamp: 0)
                )
            )
        } label: {
            Label("Add Sample Stroke", systemImage: "scribble")
        }
        .disabled(!isOverlayVisible)
    }
}

#Preview {
    ContentView()
}
