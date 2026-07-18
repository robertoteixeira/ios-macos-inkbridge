//
//  LocalBridgeOverlayIntegrationTests.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 18/07/2026.
//

import Testing
@testable import InkBridgeMac
import InkBridgeNetworking
import InkBridgeProtocol

@Test func localBridgeCanDriveOverlayViewModel() {
    let viewModel = OverlayViewModel()

    let bridge = LocalRemoteInputBridge { event in
        viewModel.handle(event)
    }

    for event in SampleOverlayEvents.strokeEvents() {
        bridge.send(event)
    }

    #expect(viewModel.strokes.count == 1)
    #expect(viewModel.activeStroke == nil)
}
