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

        let length = frame.prefix(headerSize).reduce(UInt32(0)) { value, byte in
            (value << 8) | UInt32(byte)
        }

        let payloadStartOffset = headerSize
        let payloadEndOffset = payloadStartOffset + Int(length)

        guard frame.count >= payloadEndOffset else {
            return nil
        }

        let payloadStart = frame.index(frame.startIndex, offsetBy: payloadStartOffset)
        let payloadEnd = frame.index(frame.startIndex, offsetBy: payloadEndOffset)

        return Data(frame[payloadStart..<payloadEnd])
    }
}