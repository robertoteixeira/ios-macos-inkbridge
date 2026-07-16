//
//  RemoteInputEvent+DisplayName.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 16/07/2026.
//

import InkBridgeProtocol

extension RemoteInputEvent {
    var displayName: String {
        switch self {
        case .strokeBegan:
            "strokeBegan"
        case .strokeMoved:
            "strokeMoved"
        case .strokeEnded:
            "strokeEnded"
        case .clearCanvas:
            "clearCanvas"
        case .undo:
            "undo"
        case .redo:
            "redo"
        case .modeChanged:
            "modeChanged"
        }
    }
}
