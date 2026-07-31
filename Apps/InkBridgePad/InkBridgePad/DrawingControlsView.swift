//
//  DrawingControlsView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 12/07/2026.
//

import SwiftUI

struct DrawingControlsView: View {
    let completedStrokeCount: Int
    let undoneStrokeCount: Int
    let canUndo: Bool
    let canRedo: Bool
    let onUndo: () -> Void
    let onRedo: () -> Void
    let onClear: () -> Void
    let recentEvents: [String]
    let connectionStatus: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text(connectionStatus)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.thinMaterial)
                .clipShape(Capsule())
            
            Text("\(completedStrokeCount) strokes")
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.thinMaterial)
                .clipShape(Capsule())

            Text("\(undoneStrokeCount) redo")
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.thinMaterial)
                .clipShape(Capsule())

            HStack(spacing: 8) {
                Button(action: onUndo) {
                    Image(systemName: "arrow.uturn.backward")
                }
                .accessibilityLabel("Undo")
                .disabled(!canUndo)

                Button(action: onRedo) {
                    Image(systemName: "arrow.uturn.forward")
                }
                .accessibilityLabel("Redo")
                .disabled(!canRedo)
            }
            
            VStack(alignment: .trailing, spacing: 4) {
                ForEach(Array(recentEvents.enumerated()), id: \.offset) { _, event in
                    Text(event)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Button(action: onClear) {
                Label("Clear", systemImage: "trash")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview("Enabled") {
    DrawingControlsView(
        completedStrokeCount: 3,
        undoneStrokeCount: 1,
        canUndo: true,
        canRedo: true,
        onUndo: {},
        onRedo: {},
        onClear: {},
        recentEvents: ["strokeEnded", "strokeMoved", "strokeBegan"],
        connectionStatus: "Connected"
    )
    .padding()
}

#Preview("Empty") {
    DrawingControlsView(
        completedStrokeCount: 0,
        undoneStrokeCount: 0,
        canUndo: false,
        canRedo: false,
        onUndo: {},
        onRedo: {},
        onClear: {},
        recentEvents: [],
        connectionStatus: "Disconnected"
    )
    .padding()
}
