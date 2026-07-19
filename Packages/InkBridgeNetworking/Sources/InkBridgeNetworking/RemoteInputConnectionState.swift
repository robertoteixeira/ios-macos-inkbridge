public enum RemoteInputConnectionState: Equatable, Sendable {
    case disconnected
    case connecting
    case connected
    case failed(String)
}