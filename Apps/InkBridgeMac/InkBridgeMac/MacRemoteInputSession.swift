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
    private var listener: RemoteInputListener?
    private var connection: RemoteInputConnection?

    var eventLog = RemoteInputEventLog()
    var connectionState: RemoteInputConnectionState = .disconnected

    init(eventHandler: @escaping (RemoteInputEvent) -> Void) {
        self.eventHandler = eventHandler
    }

    func send(_ event: RemoteInputEvent) {
        if transport == nil {
            transport = makeLocalTransport()
        }

        transport?.send(event)
    }
    
    func startListening(port: UInt16 = 9876) {
        guard listener == nil else {
            return
        }
        
        do {
            let listener = try NetworkRemoteInputEventListener(
                port: port,
                onConnection: { [weak self] connection in
                    self?.connection = connection
                    self?.connectionState = connection.state
                    connection.start()
                },
                onEvent: { [weak self] event in
                    self?.handle(event)
                }
            )
            
            self.listener = listener
            listener.start()
        } catch {
            eventLog = eventLog.adding(.modeChanged(.overlay))
        }
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
