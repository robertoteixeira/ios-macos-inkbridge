import Foundation
import InkBridgeProtocol

public enum RemoteInputEventCodec {
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    public static func encode(_ event: RemoteInputEvent) throws -> Data {
        try encoder.encode(event)
    }

    public static func decode(_ data: Data) throws -> RemoteInputEvent {
        try decoder.decode(RemoteInputEvent.self, from: data)
    }
}