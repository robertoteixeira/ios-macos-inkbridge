import Foundation
import InkBridgeProtocol

public final class FramedRemoteInputTransport: RemoteInputTransport {
    private let byteTransport: RemoteInputByteTransport

    public init(byteTransport: RemoteInputByteTransport) {
        self.byteTransport = byteTransport
    }

    public func send(_ event: RemoteInputEvent) {
        do {
            let frame = try RemoteInputEventMessageCodec.encode(event)
            byteTransport.send(frame)
        } catch {
            assertionFailure("Failed to encode remote input event: \(error)")
        }
    }
}