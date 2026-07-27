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

    var eventLog = RemoteInputEventLog()

    func send(_ event: RemoteInputEvent) {
        if transport == nil {
            transport = makeLocalTransport()
        }

        transport?.send(event)
    }
    
    func connectToHost(_ host: String, port: UInt16 = 9876) {
        guard connection == nil else {
            return
        }
        
        let connection = NetworkRemoteInputConnectionFactory.makeHostConnection(
            host: host,
            port: port
        )

        self.connection = connection
        transport = FramedRemoteInputTransport(byteTransport: connection)

        connection.start()
    }

    private func makeLocalTransport() -> RemoteInputTransport {
        LocalRemoteInputTransport { [weak self] event in
            self?.handle(event)
        }
    }

    private func handle(_ event: RemoteInputEvent) {
        eventLog = eventLog.adding(event)
    }
}
