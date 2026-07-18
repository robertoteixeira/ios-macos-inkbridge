//
//  LocalTransportEventLogIntegrationTests.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 18/07/2026.
//

import Testing
@testable import InkBridgePad
import InkBridgeNetworking
import InkBridgeProtocol

@Test func localTransportCanDriveEventLog() {
    var eventLog = RemoteInputEventLog()

    let transport = LocalRemoteInputTransport { event in
        eventLog = eventLog.adding(event)
    }

    transport.send(.undo)
    transport.send(.redo)
    transport.send(.clearCanvas)

    #expect(eventLog.entries == ["clearCanvas", "redo", "undo"])
}
