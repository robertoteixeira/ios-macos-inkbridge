import Foundation

public protocol RemoteInputConnection {
    var state: RemoteInputConnectionState { get }

    func start()
    func stop()
    func send(_ data: Data)
}