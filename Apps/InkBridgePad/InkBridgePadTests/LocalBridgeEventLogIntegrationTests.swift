//
//  LocalBridgeEventLogIntegrationTests.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 18/07/2026.
//

import Testing
@testable import InkBridgePad
import InkBridgeNetworking
import InkBridgeProtocol

@Test func localBridgeCanDriveEventLog() {
    var eventLog = RemoteInputEventLog()

    let bridge = LocalRemoteInputBridge { event in
        eventLog = eventLog.adding(event)
    }

    bridge.send(.undo)
    bridge.send(.redo)
    bridge.send(.clearCanvas)

    #expect(eventLog.entries == ["clearCanvas", "redo", "undo"])
}
