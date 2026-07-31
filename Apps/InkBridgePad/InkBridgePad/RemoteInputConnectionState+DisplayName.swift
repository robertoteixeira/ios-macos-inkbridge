//
//  RemoteInputConnectionState+DisplayName.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 30/07/2026.
//

import InkBridgeNetworking

extension RemoteInputConnectionState {
    var displayName: String {
        switch self {
        case .disconnected:
            "Disconnected"
        case .connecting:
            "Connecting"
        case .connected:
            "Connected"
        case .failed:
            "Failed"
        }
    }
}
