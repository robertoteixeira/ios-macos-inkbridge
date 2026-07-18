import InkBridgeProtocol

public final class LocalRemoteInputTransport: RemoteInputTransport {
    private let onEvent: (RemoteInputEvent) -> Void

    public init(onEvent: @escaping (RemoteInputEvent) -> Void) {
        self.onEvent = onEvent
    }

    public func send(_ event: RemoteInputEvent) {
        onEvent(event)
    }
}
