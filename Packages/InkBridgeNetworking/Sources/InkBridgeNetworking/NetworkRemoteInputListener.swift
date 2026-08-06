import Foundation
import Network

@available(macOS 10.14, iOS 12.0, *)
public final class NetworkRemoteInputListener: RemoteInputListener, @unchecked Sendable {
    private let listener: NWListener
    private let onConnection: (RemoteInputConnection) -> Void
    private let onData: (Data) -> Void
    private let onConnectionStateChange: ((RemoteInputConnectionState) -> Void)?
    private let onStateChange: ((RemoteInputConnectionState) -> Void)?

    public private(set) var state: RemoteInputConnectionState = .disconnected

    public init(
        port: UInt16,
        serviceName: String? = nil,
        serviceType: String? = nil,
        onConnection: @escaping (RemoteInputConnection) -> Void,
        onData: @escaping (Data) -> Void,
        onConnectionStateChange: ((RemoteInputConnectionState) -> Void)? = nil,
        onStateChange: ((RemoteInputConnectionState) -> Void)? = nil
    ) throws {
        let port = NWEndpoint.Port(rawValue: port) ?? .any

        self.listener = try NWListener(
            using: .tcp,
            on: port
        )
        self.onConnection = onConnection
        self.onData = onData
        self.onConnectionStateChange = onConnectionStateChange
        self.onStateChange = onStateChange

        if let serviceName, let serviceType {
            self.listener.service = NWListener.Service(
                name: serviceName,
                type: serviceType
            )
        }
    }

    public func start() {
        updateState(.connecting)

        listener.stateUpdateHandler = { [weak self] state in
            self?.handle(state)
        }

        listener.newConnectionHandler = { [weak self] connection in
            let remoteConnection = NetworkRemoteInputConnection(
                connection: connection,
                onData: self?.onData,
                onStateChange: self?.onConnectionStateChange
            )
            self?.onConnection(remoteConnection)
        }

        listener.start(queue: .main)
    }

    public func stop() {
        listener.cancel()
        updateState(.disconnected)
    }

    private func handle(_ nwState: NWListener.State) {
        switch nwState {
        case .setup:
            updateState(.disconnected)
        case .waiting(let error):
            updateState(.failed(error.localizedDescription))
        case .ready:
            updateState(.connected)
        case .failed(let error):
            updateState(.failed(error.localizedDescription))
        case .cancelled:
            updateState(.disconnected)
        @unknown default:
            updateState(.failed("Unknown listener state"))
        }
    }

    private func updateState(_ state: RemoteInputConnectionState) {
        self.state = state
        onStateChange?(state)
    }
}