import Foundation

public struct CanvasSize: Sendable, Equatable {
    public let width: Double
    public let height: Double

    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
}

public struct CanvasPoint: Sendable, Equatable {
    public let x: Double
    public let y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

public enum CoordinateMapper {
    public static func mapNormalizedPoint(
        x: Double,
        y: Double,
        to canvasSize: CanvasSize
    ) -> CanvasPoint {
        CanvasPoint(
            x: x * canvasSize.width,
            y: y * canvasSize.height
        )
    }
}