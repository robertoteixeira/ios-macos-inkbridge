//
//  PadRemoteInputSession.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 18/07/2026.
//

import Foundation
import InkBridgeNetworking
import InkBridgeProtocol

@Observable
final class PadRemoteInputSession {
    private var transport: RemoteInputTransport?
    private var connection: RemoteInputConnection?
    private var serviceBrowser: NetworkRemoteInputServiceBrowser?

    var eventLog = RemoteInputEventLog()
    var connectionState: RemoteInputConnectionState = .disconnected
    var discoveredServices: [RemoteInputDiscoveredService] = []
    var browserState: RemoteInputConnectionState = .disconnected
    
    func send(_ event: RemoteInputEvent) {
        if transport == nil {
            transport = makeLocalTransport()
        }

        eventLog = eventLog.adding(event)
        transport?.send(event)
    }
    
    func connectToHost(_ host: String, port: UInt16 = RemoteInputNetworkDefaults.port) {
        if connection != nil {
            switch connectionState {
            case .disconnected, .failed:
                disconnect()
            case .connecting, .connected:
                return
            }
        }
        
        connectionState = .connecting
        
        let connection = NetworkRemoteInputConnectionFactory.makeHostConnection(
            host: host,
            port: port,
            onStateChange: { [weak self] state in
                self?.connectionState = state
            }
        )

        self.connection = connection
        transport = FramedRemoteInputTransport(byteTransport: connection)

        connection.start()
        connectionState = connection.state
    }

    func startBrowsingForRemoteInputs() {
        guard serviceBrowser == nil else {
            return
        }

        browserState = .connecting

        let browser = NetworkRemoteInputServiceBrowser(
            onServicesChanged: { [weak self] services in
                self?.discoveredServices = services
            },
            onStateChanged: { [weak self] state in
                self?.browserState = state
            }
        )

        serviceBrowser = browser
        browser.start()
    }

    func stopBrowsingForRemoteInputs() {
        serviceBrowser?.stop()
        serviceBrowser = nil
        discoveredServices = []
        browserState = .disconnected
    }

    func connect(to service: RemoteInputDiscoveredService) {
        if connection != nil {
            switch connectionState {
            case .disconnected, .failed:
                disconnect()
            case .connecting, .connected:
                return
            }
        }

        connectionState = .connecting

        let connection = NetworkRemoteInputConnectionFactory.makeConnection(
            to: service,
            onStateChange: { [weak self] state in
                self?.connectionState = state
            }
        )

        self.connection = connection
        transport = FramedRemoteInputTransport(byteTransport: connection)

        connection.start()
        connectionState = connection.state
    }
    
    func disconnect() {
        connection?.stop()
        connection = nil
        transport = nil
        connectionState = .disconnected
    }

    private func makeLocalTransport() -> RemoteInputTransport {
        LocalRemoteInputTransport { _ in }
    }
}
