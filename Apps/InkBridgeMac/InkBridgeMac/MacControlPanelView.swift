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
    let onUndo: () -> Void
    let onRedo: () -> Void
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
            .accessibilityLabel(isOverlayVisible ? "Hide overlay" : "Show overlay")

            Button(action: onClearOverlay) {
                Label("Clear Overlay", systemImage: "trash")
            }
            .disabled(!isOverlayVisible)
            .accessibilityLabel("Clear overlay")
            
            HStack(spacing: 8) {
                Button(action: onUndo) {
                    Image(systemName: "arrow.uturn.backward")
                }
                .accessibilityLabel("Undo overlay stroke")
                .disabled(!isOverlayVisible)

                Button(action: onRedo) {
                    Image(systemName: "arrow.uturn.forward")
                }
                .accessibilityLabel("Redo overlay stroke")
                .disabled(!isOverlayVisible)
            }

            Button(action: onAddTestStroke) {
                Label("Add Test Stroke", systemImage: "scribble.variable")
            }
            .disabled(!isOverlayVisible)
            .accessibilityLabel("Add test stroke")

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
        onUndo: {},
        onRedo: {},
        onAddTestStroke: {}
    )
    .padding()
}

#Preview("Hidden") {
    MacControlPanelView(
        isOverlayVisible: false,
        onToggleOverlay: {},
        onClearOverlay: {},
        onUndo: {},
        onRedo: {},
        onAddTestStroke: {},
    )
    .padding()
}
