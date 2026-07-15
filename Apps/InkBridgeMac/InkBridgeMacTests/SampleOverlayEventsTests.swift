//
//  SampleOverlayEventsTests.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 15/07/2026.
//

import Testing
@testable import InkBridgeMac
import InkBridgeProtocol

@Test func sampleOverlayEventsCreateCompleteStrokeSequence() {
    let events = SampleOverlayEvents.strokeEvents()

    #expect(events.count == 3)

    guard case .strokeBegan = events[0] else {
        #expect(Bool(false), "First event should begin a stroke")
        return
    }

    guard case let .strokeMoved(points) = events[1] else {
        #expect(Bool(false), "Second event should move a stroke")
        return
    }

    #expect(points.count == 2)

    guard case .strokeEnded = events[2] else {
        #expect(Bool(false), "Third event should end a stroke")
        return
    }
}
