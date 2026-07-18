//
//  OverlayEventReplayer.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 17/07/2026.
//

import Foundation
import InkBridgeProtocol

struct OverlayEventReplayer {
    let events: [RemoteInputEvent]

    func replay(into handler: (RemoteInputEvent) -> Void) {
        for event in events {
            handler(event)
        }
    }
}
