//
//  MacRemoteInputSession.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 18/07/2026.
//

import Foundation
import InkBridgeNetworking
import InkBridgeProtocol

@Observable
final class MacRemoteInputSession {
    private var transport: RemoteInputTransport?
    private let eventHandler: (RemoteInputEvent) -> Void

    var eventLog = RemoteInputEventLog()

    init(eventHandler: @escaping (RemoteInputEvent) -> Void) {
        self.eventHandler = eventHandler
    }

    func send(_ event: RemoteInputEvent) {
        if transport == nil {
            transport = makeLocalTransport()
        }

        transport?.send(event)
    }

    private func makeLocalTransport() -> RemoteInputTransport {
        LocalRemoteInputTransport { [weak self] event in
            self?.handle(event)
        }
    }

    private func handle(_ event: RemoteInputEvent) {
        eventHandler(event)
        eventLog = eventLog.adding(event)
    }
}
