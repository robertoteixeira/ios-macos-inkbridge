import Foundation
import InkBridgeProtocol

public final class RemoteInputEventReceiver {
    private var decoder = RemoteInputEventStreamDecoder()
    private let onEvent: (RemoteInputEvent) -> Void

    public init(onEvent: @escaping (RemoteInputEvent) -> Void) {
        self.onEvent = onEvent
    }

    public func receive(_ data: Data) throws {
        let events = try decoder.append(data)

        for event in events {
            onEvent(event)
        }
    }
}