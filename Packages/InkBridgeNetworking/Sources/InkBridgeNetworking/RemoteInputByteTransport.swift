import Foundation

public protocol RemoteInputByteTransport {
    func send(_ data: Data)
}