public protocol RemoteInputListener {
    var state: RemoteInputConnectionState { get }

    func start()
    func stop()
}