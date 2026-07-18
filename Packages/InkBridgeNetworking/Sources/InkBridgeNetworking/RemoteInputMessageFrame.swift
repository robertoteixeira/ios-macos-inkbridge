import Foundation

public enum RemoteInputMessageFrame {
    public static func encode(_ payload: Data) -> Data {
        var length = UInt32(payload.count).bigEndian
        var frame = Data(bytes: &length, count: MemoryLayout<UInt32>.size)
        frame.append(payload)
        return frame
    }

    public static func decode(_ frame: Data) -> Data? {
        let headerSize = MemoryLayout<UInt32>.size

        guard frame.count >= headerSize else {
            return nil
        }

        let length = frame.prefix(headerSize).withUnsafeBytes { buffer in
            buffer.load(as: UInt32.self).bigEndian
        }

        let payloadStart = headerSize
        let payloadEnd = payloadStart + Int(length)

        guard frame.count >= payloadEnd else {
            return nil
        }

        return frame[payloadStart..<payloadEnd]
    }
}