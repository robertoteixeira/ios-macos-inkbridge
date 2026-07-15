//
//  RemoteInputEvent+DisplayName.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 15/07/2026.
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
