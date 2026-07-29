//
//  PadRemoteInputSessionTests.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 18/07/2026.
//

import Testing
@testable import InkBridgePad
import InkBridgeProtocol
import InkBridgeNetworking

@Test func padRemoteInputSessionRecordsSentEvents() {
    let session = PadRemoteInputSession()

    session.send(.undo)
    session.send(.redo)

    #expect(session.eventLog.entries == ["redo", "undo"])
}

@Test func padRemoteInputSessionStartsDisconnected() {
    let session = PadRemoteInputSession()
    
    #expect(session.connectionState == .disconnected)
}
