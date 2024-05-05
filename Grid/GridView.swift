// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class GridView {
    let camera: SKCameraNode
    let cellSizeInPixels: CGSize
    let grid: Grid<GridCell>
    let gridLinesRootNode: SKNode
    let originPositionInScene: CGPoint
    let rootNode: SKNode

    let gridLineSprites: [SKSpriteNode]
    var selectionStageCells = Set<GridCell>()

    init(scene: CScene, grid: Grid<GridCell>, cellSizeInPixels: CGSize, camera: SKCameraNode, rootNode: SKNode) {
        self.camera = camera
        self.cellSizeInPixels = cellSizeInPixels
        self.grid = grid
        self.rootNode = rootNode

        let gridLinesRootNode = SKNode()
        rootNode.addChild(gridLinesRootNode)

        let gridWidthInPixels = Double(grid.size.width) * cellSizeInPixels.width
        let gridHeightInPixels = Double(grid.size.height) * cellSizeInPixels.height

        let ww = Double(grid.size.width) / 2
        let verticals = stride(from: -ww, through: ww, by: 1).map { x in
            let sprite = SKSpriteNode(imageNamed: "pixel_1x1")
            sprite.size.height = gridHeightInPixels
            sprite.position.x = x * cellSizeInPixels.width
            sprite.color = .yellow
            gridLinesRootNode.addChild(sprite)
            return sprite
        }

        let hh = Double(grid.size.height) / 2
        let horizontals = stride(from: -hh, through: hh, by: 1).map { y in
            let sprite = SKSpriteNode(imageNamed: "pixel_1x1")
            sprite.size.width = gridWidthInPixels
            sprite.position.y = y * cellSizeInPixels.height
            sprite.color = .yellow
            gridLinesRootNode.addChild(sprite)
            return sprite
        }

        self.gridLineSprites = verticals + horizontals
        self.gridLinesRootNode = gridLinesRootNode

        switch grid.origin {
        case .center:
            originPositionInScene = .zero
        case .lowerLeft:
            originPositionInScene = CGPoint(scene.size / 2) + CGPoint(x: -gridWidthInPixels / 2, y: -gridHeightInPixels / 2)
        case .upperLeft:
            originPositionInScene = CGPoint(scene.size / 2) + CGPoint(x: -gridWidthInPixels / 2, y: gridHeightInPixels / 2)
        }
    }

    func convertPointFromScene(position: CGPoint) -> GridPoint {
        let x: Double
        if grid.size.width.isMultiple(of: 2) {
            x = (position.x / cellSizeInPixels.width).rounded(.awayFromZero)
        } else {
            let halfACellWidth = -sign(position.x) * cellSizeInPixels.width / 2
            x = ((position.x - halfACellWidth) / cellSizeInPixels.width).rounded(.towardZero)
        }

        let y: Double
        if grid.size.width.isMultiple(of: 2) {
            y = (position.y / cellSizeInPixels.height).rounded(.awayFromZero)
        } else {
            let halfACellHeight = -sign(position.y) * cellSizeInPixels.height / 2
            y = ((position.y - halfACellHeight) / cellSizeInPixels.height).rounded(.towardZero)
        }

        let yFlip: Double = (grid.yAxis == .upIsPositive) ? -1 : 1
        let gridPoint = GridPoint(x: Int(x), y: Int(y * yFlip))

        let shiftedForOriginAndYAxis = (grid.origin == .center) ?
            gridPoint : gridPoint + GridPoint(x: grid.size.width / 2, y: grid.size.height / 2)

        return shiftedForOriginAndYAxis
    }

    func convertPointToScene(position: GridPoint) -> CGPoint {
        CGPoint(x: CGFloat(position.x) * cellSizeInPixels.width, y: CGFloat(position.y) * cellSizeInPixels.height)
    }

    func getOverlappedCells(from startVertexInScene: CGPoint, to endVertexInScene: CGPoint) -> Set<GridCell> {
        // Allow for the start/end points to be swapped, that is, the user has
        // dragged upward and/or leftward from the drag origin
        let virtualStartX = startVertexInScene.x < endVertexInScene.x ? startVertexInScene.x : endVertexInScene.x
        let virtualStartY = startVertexInScene.y > endVertexInScene.y ? startVertexInScene.y : endVertexInScene.y

        let virtualEndX = endVertexInScene.x < startVertexInScene.x ? startVertexInScene.x : endVertexInScene.x
        let virtualEndY = endVertexInScene.y > startVertexInScene.y ? startVertexInScene.y : endVertexInScene.y

        let virtualStartInScene = CGPoint(x: virtualStartX, y: virtualStartY)
        let virtualEndInScene = CGPoint(x: virtualEndX, y: virtualEndY)

        let virtualStartInGrid = convertPointFromScene(position: virtualStartInScene)
        let virtualEndInGrid = convertPointFromScene(position: virtualEndInScene)

        var cells = Set<GridCell>()

        (virtualStartInGrid.x ... virtualEndInGrid.x).forEach { x in
            (virtualStartInGrid.y ... virtualEndInGrid.y).forEach { y in
                let p = GridPoint(x: x, y: y)
                if grid.isOnGrid(p) {
                    cells.insert(grid.cellAt(p))
                }
            }
        }

        return cells
    }

    func showGridLines(_ show: Bool) {
        gridLinesRootNode.isHidden = !show
    }

    func updateSelectionStagingHilite(from startVertexInScene: CGPoint, to endVertexInScene: CGPoint) {
        let currentStagedCells = selectionStageCells
        let newStagedCells = getOverlappedCells(from: startVertexInScene, to: endVertexInScene)

        let toHilite = newStagedCells.subtracting(currentStagedCells)
        let toUnhilite = currentStagedCells.subtracting(newStagedCells)

        toHilite.forEach { ($0.contents! as! CCellContents).selectionHiliteSprite.isHidden = false }
        toUnhilite.forEach { ($0.contents! as! CCellContents).selectionHiliteSprite.isHidden = true }

        self.selectionStageCells = newStagedCells
    }
}
