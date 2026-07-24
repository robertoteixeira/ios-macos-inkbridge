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
        onConnection: @escaping (RemoteInputConnection) -> Void,
        onEvent: @escaping (RemoteInputEvent) -> Void
    ) throws {
        let eventReceiver = RemoteInputEventReceiver(onEvent: onEvent)

        self.eventReceiver = eventReceiver
        self.listener = try NetworkRemoteInputListener(
            port: port,
            onConnection: onConnection,
            onData: { data in
                try? eventReceiver.receive(data)
            }
        )
    }

    public func start() {
        listener.start()
    }

    public func stop() {
        listener.stop()
    }
}