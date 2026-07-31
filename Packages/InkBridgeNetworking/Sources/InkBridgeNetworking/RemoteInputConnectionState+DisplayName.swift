public extension RemoteInputConnectionState {
    var displayName: String {
        switch self {
        case .disconnected:
            "Disconnected"
        case .connecting:
            "Connecting"
        case .connected:
            "Connected"
        case .failed:
            "Failed"
        }
    }
}