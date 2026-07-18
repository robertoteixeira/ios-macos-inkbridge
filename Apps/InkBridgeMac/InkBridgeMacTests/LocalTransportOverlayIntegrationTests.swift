//
//  LocalTransportOverlayIntegrationTests.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 18/07/2026.
//

import Testing
@testable import InkBridgeMac
import InkBridgeNetworking
import InkBridgeProtocol

@Test func localTransportCanDriveOverlayViewModel() {
    let viewModel = OverlayViewModel()

    let transport = LocalRemoteInputTransport { event in
        viewModel.handle(event)
    }

    for event in SampleOverlayEvents.strokeEvents() {
        transport.send(event)
    }

    #expect(viewModel.strokes.count == 1)
    #expect(viewModel.activeStroke == nil)
}
