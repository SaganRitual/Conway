import Foundation

struct GridPoint {
    let x: Int
    let y: Int

    static var zero: GridPoint { GridPoint(x: 0, y: 0) }

    static func + (_ lhs: GridPoint, _ rhs: GridPoint) -> GridPoint {
        GridPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func += (_ L: inout GridPoint, _ R: GridPoint) { L = L + R }

    static func - (_ lhs: GridPoint, _ rhs: GridPoint) -> GridPoint {
        return GridPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func -= (_ L: inout GridPoint, _ R: GridPoint) { L = L - R }

    static func * (_ lhs: GridPoint, _ rhs: Int) -> GridPoint {
        return GridPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func *= (_ L: inout GridPoint, R: Int) { L = L * R }

    static func / (_ lhs: GridPoint, _ rhs: Int) -> GridPoint {
        return GridPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    static func /= (_ L: inout GridPoint, R: Int) { L = L / R }
}

extension GridPoint: Equatable, Hashable {}

#if DEBUG
extension GridPoint: CustomDebugStringConvertible {
    var debugDescription: String { String(format: "(%+d, %+d)", x, y) }
}
#else
extension GridPoint: CustomStringConvertible {
    var description: String { String(format: "(%+d, %+d)", x, y) }
}
#endif
