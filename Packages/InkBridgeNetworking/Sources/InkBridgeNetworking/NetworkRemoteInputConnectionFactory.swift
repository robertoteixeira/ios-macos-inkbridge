import Foundation
import Network

@available(macOS 10.15, iOS 13.0, *)
public enum NetworkRemoteInputConnectionFactory {
    public static func makeHostConnection(
        host: String,
        port: UInt16,
        onStateChange: ((RemoteInputConnectionState) -> Void)? = nil
    ) -> NetworkRemoteInputConnection {
        let endpoint = NWEndpoint.Host(host)
        let port = NWEndpoint.Port(rawValue: port) ?? .any
        let connection = NWConnection(
            host: endpoint,
            port: port,
            using: .tcp
        )

        return NetworkRemoteInputConnection(connection: connection, onStateChange: onStateChange)
    }
    
    public static func makeConnection(
        to service: RemoteInputDiscoveredService,
        onStateChange: ((RemoteInputConnectionState) -> Void)? = nil
    ) -> NetworkRemoteInputConnection {
        let connection = NWConnection(
            to: service.endpoint,
            using: .tcp
        )

        return NetworkRemoteInputConnection(
            connection: connection,
            onStateChange: onStateChange
        )
    }
}
