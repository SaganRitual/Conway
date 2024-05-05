import Foundation

struct GridSize: Hashable {
    func area() -> Int { return width * height }

    let width: Int; let height: Int

    init(_ size: GridSize) { width = size.width; height = size.height }
    init(width: Int, height: Int) { self.width = width; self.height = height }

    static let zero = GridSize(width: 0, height: 0)

    static func + (_ lhs: GridSize, _ rhs: GridSize) -> GridSize {
        return GridSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func - (_ lhs: GridSize, _ rhs: GridSize) -> GridSize {
        return GridSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func * (_ lhs: GridSize, _ rhs: Int) -> GridSize {
        return GridSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}

extension GridSize: CustomStringConvertible {
    public var description: String {
        String(format: "%d", width) + " x " + String(format: "%d", height)
    }
}
