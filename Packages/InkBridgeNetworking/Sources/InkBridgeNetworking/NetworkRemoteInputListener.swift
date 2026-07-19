import Foundation
import Network

@available(macOS 10.14, iOS 12.0, *)
public final class NetworkRemoteInputListener: RemoteInputListener, @unchecked Sendable {
    private let listener: NWListener
    private let onConnection: (NetworkRemoteInputConnection) -> Void

    public private(set) var state: RemoteInputConnectionState = .disconnected

    public init(
        port: UInt16,
        onConnection: @escaping (NetworkRemoteInputConnection) -> Void
    ) throws {
        let port = NWEndpoint.Port(rawValue: port) ?? .any

        self.listener = try NWListener(
            using: .tcp,
            on: port
        )
        self.onConnection = onConnection
    }

    public func start() {
        state = .connecting

        listener.stateUpdateHandler = { [weak self] state in
            self?.handle(state)
        }

        listener.newConnectionHandler = { [weak self] connection in
            let remoteConnection = NetworkRemoteInputConnection(connection: connection)
            self?.onConnection(remoteConnection)
        }

        listener.start(queue: .main)
    }

    public func stop() {
        listener.cancel()
        state = .disconnected
    }

    private func handle(_ nwState: NWListener.State) {
        switch nwState {
        case .setup:
            state = .disconnected
        case .waiting(let error):
            state = .failed(error.localizedDescription)
        case .ready:
            state = .connected
        case .failed(let error):
            state = .failed(error.localizedDescription)
        case .cancelled:
            state = .disconnected
        @unknown default:
            state = .failed("Unknown listener state")
        }
    }
}