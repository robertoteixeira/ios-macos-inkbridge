import Foundation
import InkBridgeProtocol

public struct RemoteInputEventStreamDecoder {
    private var frameDecoder = RemoteInputMessageFrameDecoder()

    public init() {}

    public mutating func append(_ data: Data) throws -> [RemoteInputEvent] {
        let payloads = frameDecoder.append(data)

        return try payloads.map { payload in
            try RemoteInputEventCodec.decode(payload)
        }
    }
}