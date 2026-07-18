//
//  OverlayEventReplayerTests.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 17/07/2026.
//

import Testing
@testable import InkBridgeMac
import InkBridgeProtocol

@Test func overlayEventReplayerReplaysEventsInOrder() {
    let events: [RemoteInputEvent] = [
        .undo,
        .redo,
        .clearCanvas
    ]

    var replayedEvents: [RemoteInputEvent] = []

    OverlayEventReplayer(events: events).replay { event in
        replayedEvents.append(event)
    }

    #expect(replayedEvents == events)
}
