// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

enum GridCore {
    enum Origin { case center, lowerLeft, upperLeft }
    enum yAxis  { case upIsPositive, upIsNegative }
}

class Grid<T: GridCellProtocol> {
    let origin: GridCore.Origin
    let size: GridSize
    let theCells: [T]
    let wrap: Bool
    let yAxis: GridCore.yAxis

    init(
        size: GridSize,
        origin: GridCore.Origin = .upperLeft,
        yAxis: GridCore.yAxis = .upIsNegative,
        wrap: Bool = false
    ) {
        if origin == .center {
            assert(
                size.width % 2 == 1 && size.height % 2 == 1,
                "Center-origin grid requires a cell at (0, 0): w and h must both be odd"
            )
        } else if origin == .lowerLeft {
            assert(yAxis == .upIsPositive, "Lower-left origin grid currently supports only up-positive y-axis")
        } else if origin == .upperLeft {
            assert(yAxis == .upIsNegative, "Upper-left origin grid currently supports only up-negative y-axis")
        }

        self.origin = origin
        self.size = size
        self.wrap = wrap
        self.yAxis = yAxis

        self.theCells = (0..<size.area()).map {
            let gridPosition = Grid.getPosition(
                absoluteIndex: $0, gridSize: size, origin: origin
            )

            return Grid.makeCell(gridPosition)
        }
    }

    func cellAt(_ absoluteIndex: Int) -> T {
        let p = getPosition(absoluteIndex: absoluteIndex)
        return cellAt(p)
    }

    func cellAt(_ gridPosition: GridPoint) -> T {
        assert(isOnGrid(gridPosition))

        switch origin {
        case .center:    return cellAt_oCenter(gridPosition)
        case .lowerLeft: return cellAt_oLowerLeft(gridPosition)
        case .upperLeft: return cellAt_oUpperLeft(gridPosition)
        }
    }

    func getPosition(absoluteIndex: Int) -> GridPoint {
        Grid.getPosition(
            absoluteIndex: absoluteIndex, gridSize: size, origin: origin
        )
    }

    func getRandomCell() -> T {
        let hw = size.width / 2, hh = size.height / 2
        let x = Int.random(in: -hw...hw)
        let y = Int.random(in: -hh...hh)
        return cellAt(GridPoint(x: x, y: y))
    }

    /// Indicates whether the specified position is on the grid
    ///
    /// - Parameter position: The position to check
    ///
    /// - Returns: A Bool indicating whether the point is on the grid
    func isOnGrid(_ position: GridPoint) -> Bool {
        switch origin {
        case .center:
            let hw = size.width / 2, hh = size.height / 2
            return (-hw...hw).contains(position.x) &&
                   (-hh...hh).contains(position.y)

        case .upperLeft: fallthrough
        case .lowerLeft:
            return
                (0..<size.width).contains(position.x) &&
                (0..<size.height).contains(position.y)
        }
    }

    /// For iterating over all the cells in the grid
    func makeIterator() -> IndexingIterator<[T]> { theCells.makeIterator() }

    /// For iterating over all the cells in a given rectangle
    func makeSubgrid(center: GridPoint, size: GridSize) -> [T] {
        var subgridCells = [T]()

        switch origin {
        case .center:
            let hw = size.width / 2, hh = size.height / 2

            for y in -hh...hh { for x in -hw...hw {
                // Note: -y in the GridPoint so we return with (left, top)
                // at the beginning and (right, bottom) at the end
                let offset = GridPoint(x: x, y: -y)
                let gridPosition = offset + center
                subgridCells.append(cellAt(gridPosition))
            }}

        default: fatalError("Not implemented for this mode")
        }

        return subgridCells
    }
}

private extension Grid {
    static func makeCell(_ gridPosition: GridPoint) -> T { T(gridPosition) }
}

private extension Grid {
    func mapToOnGridCoordinates(_ gridPosition: GridPoint) -> GridPoint {
        if !wrap { return gridPosition }

        func f(_ a: Int, _ fa: Int) -> Int {
            let f1 = (a % fa)

            if f1 > fa / 2 { return f1 - fa }
            else if f1 < -(fa / 2) { return f1 + fa }
            else { return f1 }
        }

        let x = f(gridPosition.x, size.width)
        let y = f(gridPosition.y, size.height)
        return GridPoint(x: x, y: y)
    }

    func cellAt_oCenter(_ gridPosition: GridPoint) -> T {
        let realGridPosition = mapToOnGridCoordinates(gridPosition)

        let halfHeight = size.height / 2
        let yy = halfHeight - realGridPosition.y

        let halfWidth = size.width / 2

        let ix = (yy * size.width) + (halfWidth + realGridPosition.x)

        return theCells[ix]
    }

    func cellAt_oLowerLeft(_ gridPosition: GridPoint) -> T {
        assert(!wrap, "Wrapping is allowed only for origin == center")
        let ix = (size.height - 1 - gridPosition.y) * size.width + gridPosition.x
        return theCells[ix]
    }

    func cellAt_oUpperLeft(_ position: GridPoint) -> T {
        assert(!wrap, "Wrapping is allowed only for origin == center")
        return theCells[position.y * size.width + position.x]
    }
}

private extension Grid {
    static func getPosition(
        absoluteIndex: Int, gridSize: GridSize, origin: GridCore.Origin
    ) -> GridPoint {
        switch origin {
        case .center:
            let halfWidth = gridSize.width / 2

            let x = absoluteIndex % gridSize.width - halfWidth
            let y = halfWidth - absoluteIndex / gridSize.width

            return GridPoint(x: x, y: y)

        case .upperLeft:
            let x = absoluteIndex % gridSize.width
            let y = absoluteIndex / gridSize.width

            return GridPoint(x: x, y: y)

        case .lowerLeft:
            let x = absoluteIndex % gridSize.width
            let y = gridSize.height - 1 - absoluteIndex / gridSize.width

            return GridPoint(x: x, y: y)
        }
    }
}
