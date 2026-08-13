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
    var listenerState: RemoteInputConnectionState = .disconnected

    init(eventHandler: @escaping (RemoteInputEvent) -> Void) {
        self.eventHandler = eventHandler
    }

    func send(_ event: RemoteInputEvent) {
        if transport == nil {
            transport = makeLocalTransport()
        }

        transport?.send(event)
    }
    
    func startListening(port: UInt16 = RemoteInputNetworkDefaults.port) {
        guard listener == nil else {
            return
        }
        
        do {
            listenerState = .connecting
            let listener = try NetworkRemoteInputEventListener(
                port: port,
                serviceName: RemoteInputServiceDefaults.name,
                serviceType: RemoteInputServiceDefaults.type,
                onConnection: { [weak self] connection in
                    self?.connection?.stop()
                    self?.connection = connection
                    self?.connectionState = connection.state
                    connection.start()
                },
                onEvent: { [weak self] event in
                    self?.handle(event)
                },
                onConnectionStateChange: { [weak self] state in
                    self?.handleConnectionStateChange(state)
                },
                onListenerStateChange: { [weak self] state in
                    self?.listenerState = state
                }
            )
            
            self.listener = listener
            listener.start()
        } catch {
            eventLog = eventLog.adding(.modeChanged(.overlay))
            listenerState = .failed(error.localizedDescription)
        }
    }
    
    func stopListening() {
        connection?.stop()
        listener?.stop()

        connection = nil
        listener = nil
        connectionState = .disconnected
        listenerState = .disconnected
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
    
    private func handleConnectionStateChange(_ state: RemoteInputConnectionState) {
        connectionState = state

        switch state {
        case .disconnected, .failed:
            connection = nil
        case .connecting, .connected:
            break
        }
    }
}
