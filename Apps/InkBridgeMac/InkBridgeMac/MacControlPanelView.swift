//
//  MacControlPanelView.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 15/07/2026.
//

import SwiftUI

struct MacControlPanelView: View {
    let isOverlayVisible: Bool
    let onToggleOverlay: () -> Void
    let onClearOverlay: () -> Void
    let onAddTestStroke: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("InkBridge Mac")
                .font(.title)

            Text(isOverlayVisible ? "Overlay visible" : "Overlay hidden")
                .foregroundStyle(.secondary)

            Button(action: onToggleOverlay) {
                Label(
                    isOverlayVisible ? "Hide Overlay" : "Show Overlay",
                    systemImage: isOverlayVisible ? "eye.slash" : "eye"
                )
            }
            .buttonStyle(.borderedProminent)

            Button(action: onClearOverlay) {
                Label("Clear Overlay", systemImage: "trash")
            }
            .disabled(!isOverlayVisible)

            Button(action: onAddTestStroke) {
                Label("Add Test Stroke", systemImage: "scribble.variable")
            }
            .disabled(!isOverlayVisible)

            Text("Local test event")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Visible") {
    MacControlPanelView(
        isOverlayVisible: true,
        onToggleOverlay: {},
        onClearOverlay: {},
        onAddTestStroke: {}
    )
    .padding()
}

#Preview("Hidden") {
    MacControlPanelView(
        isOverlayVisible: false,
        onToggleOverlay: {},
        onClearOverlay: {},
        onAddTestStroke: {}
    )
    .padding()
}
