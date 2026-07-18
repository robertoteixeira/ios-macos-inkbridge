//
//  MacRemoteInputSessionTests.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 18/07/2026.
//

import Testing
@testable import InkBridgeMac
import InkBridgeProtocol

@Test func macRemoteInputSessionRecordsAndForwardsSentEvents() {
    var handledEvents: [RemoteInputEvent] = []

    let session = MacRemoteInputSession { event in
        handledEvents.append(event)
    }

    session.send(.undo)
    session.send(.redo)

    #expect(handledEvents == [.undo, .redo])
    #expect(session.eventLog.entries == ["redo", "undo"])
}
