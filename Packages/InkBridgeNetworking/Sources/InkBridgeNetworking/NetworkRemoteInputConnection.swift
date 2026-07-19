import Foundation
import Network

@available(macOS 10.14, iOS 12.0, *)
public final class NetworkRemoteInputConnection: RemoteInputConnection, @unchecked Sendable {
    private let connection: NWConnection

    public private(set) var state: RemoteInputConnectionState = .disconnected

    public init(connection: NWConnection) {
        self.connection = connection
    }

    public func start() {
        state = .connecting

        connection.stateUpdateHandler = { [weak self] state in
            self?.handle(state)
        }

        connection.start(queue: .main)
    }

    public func stop() {
        connection.cancel()
        state = .disconnected
    }

    public func send(_ data: Data) {
        connection.send(
            content: data,
            completion: .contentProcessed { [weak self] error in
                if let error {
                    self?.state = .failed(error.localizedDescription)
                }
            }
        )
    }

    private func handle(_ nwState: NWConnection.State) {
        switch nwState {
        case .setup:
            state = .disconnected
        case .waiting(let error):
            state = .failed(error.localizedDescription)
        case .preparing:
            state = .connecting
        case .ready:
            state = .connected
        case .failed(let error):
            state = .failed(error.localizedDescription)
        case .cancelled:
            state = .disconnected
        @unknown default:
            state = .failed("Unknown connection state")
        }
    }
}
