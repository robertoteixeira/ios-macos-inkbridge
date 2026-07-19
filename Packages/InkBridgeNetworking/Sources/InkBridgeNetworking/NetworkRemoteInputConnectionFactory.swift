import Foundation
import Network

@available(macOS 10.14, iOS 12.0, *)
public enum NetworkRemoteInputConnectionFactory {
    public static func makeHostConnection(
        host: String,
        port: UInt16
    ) -> NetworkRemoteInputConnection {
        let endpoint = NWEndpoint.Host(host)
        let port = NWEndpoint.Port(rawValue: port) ?? .any
        let connection = NWConnection(
            host: endpoint,
            port: port,
            using: .tcp
        )

        return NetworkRemoteInputConnection(connection: connection)
    }
}