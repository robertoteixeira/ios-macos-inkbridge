//
//  DrawingControlsView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 12/07/2026.
//

import SwiftUI
import InkBridgeProtocol

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
    @Binding var selectedTool: DrawingTool
    @Binding var selectedColorHex: String
    @Binding var strokeWidth: Double
    
    let connectionStatus: String
    let isRemoteHostFocused: FocusState<Bool>.Binding
    let canConnect: Bool
    let canDisconnect: Bool
    let onConnect: () -> Void
    let onDisconnect: () -> Void
    let discoveredServices: [DiscoveredRemoteInputServiceItem]
    let onConnectToDiscoveredService: (DiscoveredRemoteInputServiceItem) -> Void
    let browserStatus: String
    let emptyDiscoveryMessage: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text(connectionStatus)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.thinMaterial)
                .clipShape(Capsule())
            
            Text("Discovery: \(browserStatus)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
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
                    Image(systemName: "link.slash")
                }
                .accessibilityLabel("Disconnect")
                .disabled(!canDisconnect)
            }

            VStack(alignment: .trailing, spacing: 4) {
                if discoveredServices.isEmpty {
                    Text(emptyDiscoveryMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(discoveredServices) { service in
                        Button(action: {
                            onConnectToDiscoveredService(service)
                        }) {
                            Label(service.name, systemImage: "desktopcomputer")
                        }
                        .disabled(!canConnect)
                    }
                }
            }
            
            Picker("Tool", selection: $selectedTool) {
                Text("Pen").tag(DrawingTool.pen)
                Text("Marker").tag(DrawingTool.marker)
                Text("Highlighter").tag(DrawingTool.highlighter)
            }
            .pickerStyle(.segmented)
            .frame(width: 280)

            HStack(spacing: 6) {
                ForEach(["#000000", "#FF3B30", "#007AFF", "#FFCC00"], id: \.self) { colorHex in
                    Button {
                        selectedColorHex = colorHex
                    } label: {
                        ZStack {
                            Circle()
                                .fill(color(for: colorHex))
                                .frame(width: 24, height: 24)

                            if selectedColorHex == colorHex {
                                Circle()
                                    .stroke(.primary, lineWidth: 2)
                                    .frame(width: 32, height: 32)
                            }
                        }
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(colorHex)
                }
            }

            HStack(spacing: 8) {
                Slider(value: $strokeWidth, in: 1...16)
                    .frame(width: 160)

                Capsule()
                    .fill(color(for: selectedColorHex).opacity(selectedTool == .highlighter ? 0.35 : 1.0))
                    .frame(
                        width: 44,
                        height: previewStrokeWidth
                    )
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
    
    private var previewStrokeWidth: Double {
        switch selectedTool {
        case .marker:
            return strokeWidth * 1.8
        case .highlighter:
            return strokeWidth * 2.4
        case .pen, .eraser, .laserPointer:
            return strokeWidth
        }
    }
    
    private func color(for hex: String) -> Color {
        switch hex {
        case "#FF3B30":
            return .red
        case "#007AFF":
            return .blue
        case "#FFCC00":
            return .yellow
        default:
            return .black
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
        onDisconnect: {},
        discoveredServices: [
            DiscoveredRemoteInputServiceItem(id: "InkBridge Mac", name: "InkBridge Mac")
        ],
        onConnectToDiscoveredService: { _ in },
        browserStatus: "Connected",
        emptyDiscoveryMessage: "No Macs found"
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
        onDisconnect: {},
        discoveredServices: [],
        onConnectToDiscoveredService: { _ in },
        browserStatus: "Disconnected",
        emptyDiscoveryMessage: "Searching for Macs..."
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
    let discoveredServices: [DiscoveredRemoteInputServiceItem]
    let onConnectToDiscoveredService: (DiscoveredRemoteInputServiceItem) -> Void
    let browserStatus: String
    let emptyDiscoveryMessage: String

    @State private var remoteHost = "192.168.0.6"
    @State private var selectedTool: DrawingTool = .pen
    @State private var selectedColorHex = "#000000"
    @State private var strokeWidth = 4.0
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
            selectedTool: $selectedTool,
            selectedColorHex: $selectedColorHex,
            strokeWidth: $strokeWidth,
            connectionStatus: connectionStatus,
            isRemoteHostFocused: $isRemoteHostFocused,
            canConnect: canConnect,
            canDisconnect: canDisconnect,
            onConnect: onConnect,
            onDisconnect: onDisconnect,
            discoveredServices: discoveredServices,
            onConnectToDiscoveredService: onConnectToDiscoveredService,
            browserStatus: browserStatus,
            emptyDiscoveryMessage: emptyDiscoveryMessage
        )
    }
}
