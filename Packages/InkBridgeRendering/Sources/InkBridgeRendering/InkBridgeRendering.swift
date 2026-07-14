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

public enum NormalizedCoordinate {
    public static func clamped(_ value: Double) -> Double {
        min(max(value, 0), 1)
    }
}

public struct RGBColor: Sendable, Equatable {
    public let red: Double
    public let green: Double
    public let blue: Double

    public init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}

public enum HexColorParser {
    public static func parse(_ hex: String) -> RGBColor? {
        let trimmedHex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))

        guard
            trimmedHex.count == 6,
            let value = Int(trimmedHex, radix: 16)
        else {
            return nil
        }

        return RGBColor(
            red: Double((value >> 16) & 0xFF) / 255.0,
            green: Double((value >> 8) & 0xFF) / 255.0,
            blue: Double(value & 0xFF) / 255.0
        )
    }
}