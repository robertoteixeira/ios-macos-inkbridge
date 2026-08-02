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
    @Binding var remoteHost: String
    let connectionStatus: String
    let isRemoteHostFocused: FocusState<Bool>.Binding
    let canConnect: Bool
    let canDisconnect: Bool
    let onConnect: () -> Void
    let onDisconnect: () -> Void

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text(connectionStatus)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.thinMaterial)
                .clipShape(Capsule())
            
            HStack(spacing: 8) {
                TextField("Mac IP", text: $remoteHost)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numbersAndPunctuation)
                    .submitLabel(.done)
                    .focused(isRemoteHostFocused)
                    .onSubmit {
                        isRemoteHostFocused.wrappedValue = false
                    }
                    .frame(width: 140)

                Button(action: onConnect) {
                    Label("Connect", systemImage: "link")
                }
                .disabled(!canConnect)

                Button(action: onDisconnect) {
                    Image(systemName: "link.badge.minus")
                }
                .accessibilityLabel("Disconnect")
                .disabled(!canDisconnect)
            }
            
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    isRemoteHostFocused.wrappedValue = false
                }
            }
        }
    }
}

#Preview("Enabled") {
    DrawingControlsPreview(
        completedStrokeCount: 3,
        undoneStrokeCount: 1,
        canUndo: true,
        canRedo: true,
        onUndo: {},
        onRedo: {},
        onClear: {},
        recentEvents: ["strokeEnded", "strokeMoved", "strokeBegan"],
        connectionStatus: "Connected",
        canConnect: false,
        canDisconnect: true,
        onConnect: {},
        onDisconnect: {}
    )
    .padding()
}

#Preview("Empty") {
    DrawingControlsPreview(
        completedStrokeCount: 0,
        undoneStrokeCount: 0,
        canUndo: false,
        canRedo: false,
        onUndo: {},
        onRedo: {},
        onClear: {},
        recentEvents: [],
        connectionStatus: "Disconnected",
        canConnect: true,
        canDisconnect: false,
        onConnect: {},
        onDisconnect: {}
    )
    .padding()
}

private struct DrawingControlsPreview: View {
    let completedStrokeCount: Int
    let undoneStrokeCount: Int
    let canUndo: Bool
    let canRedo: Bool
    let onUndo: () -> Void
    let onRedo: () -> Void
    let onClear: () -> Void
    let recentEvents: [String]
    let connectionStatus: String
    let canConnect: Bool
    let canDisconnect: Bool
    let onConnect: () -> Void
    let onDisconnect: () -> Void

    @State private var remoteHost = "192.168.0.6"
    @FocusState private var isRemoteHostFocused: Bool

    var body: some View {
        DrawingControlsView(
            completedStrokeCount: completedStrokeCount,
            undoneStrokeCount: undoneStrokeCount,
            canUndo: canUndo,
            canRedo: canRedo,
            onUndo: onUndo,
            onRedo: onRedo,
            onClear: onClear,
            recentEvents: recentEvents,
            remoteHost: $remoteHost,
            connectionStatus: connectionStatus,
            isRemoteHostFocused: $isRemoteHostFocused,
            canConnect: canConnect,
            canDisconnect: canDisconnect,
            onConnect: onConnect,
            onDisconnect: onDisconnect
        )
    }
}
