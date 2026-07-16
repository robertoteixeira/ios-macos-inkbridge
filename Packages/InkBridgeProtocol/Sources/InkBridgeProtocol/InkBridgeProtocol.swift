import Foundation

public enum RemoteMode: String, Codable, Sendable {
    case overlay
    case tablet
}

public enum DrawingTool: String, Codable, Sendable {
    case pen
    case marker
    case highlighter
    case eraser
    case laserPointer
}

public struct StrokePoint: Codable, Sendable, Equatable {
    public let x: Double
    public let y: Double
    public let pressure: Double
    public let timestamp: TimeInterval

    public init(
        x: Double,
        y: Double,
        pressure: Double,
        timestamp: TimeInterval
    ) {
        self.x = x
        self.y = y
        self.pressure = pressure
        self.timestamp = timestamp
    }
}

public struct StrokeStyle: Codable, Sendable, Equatable {
    public let colorHex: String
    public let width: Double
    public let opacity: Double
    public let tool: DrawingTool

    public init(
        colorHex: String,
        width: Double,
        opacity: Double,
        tool: DrawingTool
    ) {
        self.colorHex = colorHex
        self.width = width
        self.opacity = opacity
        self.tool = tool
    }
}

public enum RemoteInputEvent: Codable, Sendable, Equatable {
    case strokeBegan(StrokePoint, StrokeStyle)
    case strokeMoved([StrokePoint])
    case strokeEnded(StrokePoint)
    case clearCanvas
    case undo
    case redo
    case modeChanged(RemoteMode)
}

public extension RemoteInputEvent {
    var displayName: String {
        switch self {
        case .strokeBegan:
            "strokeBegan"
        case .strokeMoved:
            "strokeMoved"
        case .strokeEnded:
            "strokeEnded"
        case .clearCanvas:
            "clearCanvas"
        case .undo:
            "undo"
        case .redo:
            "redo"
        case .modeChanged:
            "modeChanged"
        }
    }
}

public struct RemoteInputEventLog: Sendable, Equatable {
    public let entries: [String]
    public let limit: Int

    public init(entries: [String] = [], limit: Int = 5) {
        self.entries = entries
        self.limit = limit
    }

    public func adding(_ event: RemoteInputEvent) -> RemoteInputEventLog {
        var updatedEntries = entries
        updatedEntries.insert(event.displayName, at: 0)

        if updatedEntries.count > limit {
            updatedEntries.removeLast()
        }

        return RemoteInputEventLog(
            entries: updatedEntries,
            limit: limit
        )
    }
}