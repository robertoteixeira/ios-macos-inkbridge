import InkBridgeProtocol

public protocol RemoteInputTransport {
    func send(_ event: RemoteInputEvent)
}
