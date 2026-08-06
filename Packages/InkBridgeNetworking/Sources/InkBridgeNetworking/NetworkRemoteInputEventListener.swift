import Foundation
import InkBridgeProtocol

@available(macOS 10.14, iOS 12.0, *)
public final class NetworkRemoteInputEventListener: RemoteInputListener {
    private var eventReceiver: RemoteInputEventReceiver?
    private let listener: NetworkRemoteInputListener

    public var state: RemoteInputConnectionState {
        listener.state
    }

    public init(
        port: UInt16,
        serviceName: String? = nil,
        serviceType: String? = nil,
        onConnection: @escaping (RemoteInputConnection) -> Void,
        onEvent: @escaping (RemoteInputEvent) -> Void,
        onConnectionStateChange: ((RemoteInputConnectionState) -> Void)? = nil,
        onListenerStateChange: ((RemoteInputConnectionState) -> Void)? = nil
    ) throws {
        let eventReceiver = RemoteInputEventReceiver(onEvent: onEvent)

        self.eventReceiver = eventReceiver
        self.listener = try NetworkRemoteInputListener(
            port: port,
            serviceName: serviceName,
            serviceType: serviceType,
            onConnection: onConnection,
            onData: { data in
                try? eventReceiver.receive(data)
            },
            onConnectionStateChange: onConnectionStateChange,
            onStateChange: onListenerStateChange
        )
    }

    public func start() {
        listener.start()
    }

    public func stop() {
        listener.stop()
    }
}