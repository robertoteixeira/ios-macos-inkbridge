import Foundation

public struct RemoteInputMessageFrameDecoder {
    private var buffer = Data()

    public init() {}

    public mutating func append(_ data: Data) -> [Data] {
        buffer.append(data)

        var payloads: [Data] = []

        while let payload = RemoteInputMessageFrame.decode(buffer) {
            let frameSize = MemoryLayout<UInt32>.size + payload.count
            payloads.append(payload)
            buffer.removeFirst(frameSize)
        }

        return payloads
    }
}