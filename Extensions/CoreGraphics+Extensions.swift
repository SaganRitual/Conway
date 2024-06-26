// We are a way for the cosmos to know itself. -- C. Sagan

import CoreGraphics
import GameplayKit

extension vector_int2 {
    init(_ gp: GridPoint) {
        self.init(x: Int32(gp.x), y: Int32(gp.y))
    }

    init(_ gs: GridSize) {
        self.init(x: Int32(gs.width), y: Int32(gs.height))
    }
}

extension CGPoint {
    static func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func += (_ L: inout CGPoint, _ R: CGPoint) { L = L + R }

    static func - (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func -= (_ L: inout CGPoint, _ R: CGPoint) { L = L - R }

    static func * (_ lhs: CGPoint, _ rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * Double(rhs), y: lhs.y * Double(rhs))
    }

    static func *= (_ L: inout CGPoint, R: CGFloat) { L = L * R }

    static func / (_ lhs: CGPoint, _ rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / Double(rhs), y: lhs.y / Double(rhs))
    }

    static func /= (_ L: inout CGPoint, R: CGFloat) { L = L / R }

    init(_ size: CGSize) { self.init(x: size.width, y: size.height) }
}

extension CGSize {
    static func + (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func += (_ L: inout CGSize, _ R: CGSize) { L = L + R }

    static func - (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func -= (_ L: inout CGSize, _ R: CGSize) { L = L - R }

    static func * (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * Double(rhs), height: lhs.height * Double(rhs))
    }

    static func *= (_ L: inout CGSize, R: CGFloat) { L = L * R }

    static func / (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width / Double(rhs), height: lhs.height / Double(rhs))
    }

    static func /= (_ L: inout CGSize, R: CGFloat) { L = L / R }

    init(_ position: CGPoint) { self.init(width: position.x, height: position.y) }
}
