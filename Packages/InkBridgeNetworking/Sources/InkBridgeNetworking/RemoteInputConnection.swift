import Foundation

public protocol RemoteInputConnection: RemoteInputByteTransport {
    var state: RemoteInputConnectionState { get }

    func start()
    func stop()
    func send(_ data: Data)
}