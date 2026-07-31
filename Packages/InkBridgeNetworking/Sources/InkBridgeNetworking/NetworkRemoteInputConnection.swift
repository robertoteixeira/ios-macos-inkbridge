import Foundation
import Network

@available(macOS 10.14, iOS 12.0, *)
public final class NetworkRemoteInputConnection: RemoteInputConnection, @unchecked Sendable {
    private let connection: NWConnection
    private let onData: ((Data) -> Void)?
    private let onStateChange: ((RemoteInputConnectionState) -> Void)?

    public private(set) var state: RemoteInputConnectionState = .disconnected

    public init(
        connection: NWConnection,
        onData: ((Data) -> Void)? = nil,
        onStateChange: ((RemoteInputConnectionState) -> Void)? = nil
    ) {
        self.connection = connection
        self.onData = onData
        self.onStateChange = onStateChange
    }

    public func start() {
        updateState(.connecting)

        connection.stateUpdateHandler = { [weak self] state in
            self?.handle(state)
        }

        connection.start(queue: .main)
        receiveNext()
    }

    public func stop() {
        connection.cancel()
        updateState(.disconnected)
    }

    public func send(_ data: Data) {
        connection.send(
            content: data,
            completion: .contentProcessed { [weak self] error in
                if let error {
                    self?.updateState(.failed(error.localizedDescription))
                }
            }
        )
    }

    private func receiveNext() {
        connection.receive(
            minimumIncompleteLength: 1,
            maximumLength: 65_536
        ) { [weak self] data, _, isComplete, error in
            if let data, !data.isEmpty {
                self?.onData?(data)
            }

            if let error {
                self?.updateState(.failed(error.localizedDescription))
                return
            }

            if isComplete {
                self?.updateState(.disconnected)
                return
            }

            self?.receiveNext()
        }
    }

    private func handle(_ nwState: NWConnection.State) {
        switch nwState {
        case .setup:
            updateState(.disconnected)
        case .waiting(let error):
            updateState(.failed(error.localizedDescription))
        case .preparing:
            updateState(.connecting)
        case .ready:
            updateState(.connected)
        case .failed(let error):
            updateState(.failed(error.localizedDescription))
        case .cancelled:
            updateState(.disconnected)
        @unknown default:
            updateState(.failed("Unknown connection state"))
        }
    }

    private func updateState(_ state: RemoteInputConnectionState) {
        self.state = state
        onStateChange?(state)
    }
}
