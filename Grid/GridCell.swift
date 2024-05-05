// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

protocol GridCellContentsProtocol: AnyObject {
    
}

protocol GridCellProtocol: AnyObject, Hashable {
    var gridPosition: GridPoint { get }
    init(_ gridPosition: GridPoint)
}

class GridCell: GridCellProtocol {
    let gridPosition: GridPoint
    var contents: GridCellContentsProtocol?
    required init(_ gridPosition: GridPoint) { self.gridPosition = gridPosition }
}

extension GridCell: Equatable {
    static func == (lhs: GridCell, rhs: GridCell) -> Bool {
        lhs.gridPosition == rhs.gridPosition
    }
}

extension GridCell: Hashable {
    // Each cell in the grid has a unique grid position that
    // we can use to positively identify the cell
    func hash(into hasher: inout Hasher) {
        hasher.combine(gridPosition)
    }
}
