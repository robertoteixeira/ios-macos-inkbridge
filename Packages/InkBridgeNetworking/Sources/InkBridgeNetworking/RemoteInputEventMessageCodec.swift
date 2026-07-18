import Foundation
import InkBridgeProtocol

public enum RemoteInputEventMessageCodec {
    public static func encode(_ event: RemoteInputEvent) throws -> Data {
        let payload = try RemoteInputEventCodec.encode(event)
        return RemoteInputMessageFrame.encode(payload)
    }

    public static func decode(_ frame: Data) throws -> RemoteInputEvent? {
        guard let payload = RemoteInputMessageFrame.decode(frame) else {
            return nil
        }

        return try RemoteInputEventCodec.decode(payload)
    }
}