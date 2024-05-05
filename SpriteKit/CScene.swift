// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI
import SpriteKit

final class CScene: SKScene, ObservableObject {
    static let cellSizeInPixels = CGSize(width: 10, height: 10)
    static let MIN_ZOOM: CGFloat = 0.125
    static let MAX_ZOOM: CGFloat = 8
    static let paddingAllowance = 0.9

    @Published var cameraScale: CGFloat = 0.2
    @Published var showGridLines = true
    @Published var redrawRequired = true

    let cameraNode = SKCameraNode()
    let rootNode = SKNode()

    var centerDotSprite: SKSpriteNode!
    var circleSpriteTexture: SKTexture!
    var grid: Grid<GridCell>!
    var lastUpdateTime: TimeInterval = -1
    var pixelSpriteTexture: SKTexture!
    var selectionerView: SelectionerView!

    var dotSprites = [SKSpriteNode]()

    let selectionExtentRoot = SKNode()
    var selectionExtentSprites = [SKSpriteNode]()

    let selectionHiliteRoot = SKNode()
    var selectionHiliteSprites = [SKSpriteNode]()

    @Published var gridView: GridView!

    override func didMove(to view: SKView) {
        scaleMode = .resizeFill
        backgroundColor = .black

        addChild(cameraNode)
        camera = cameraNode

        addChild(rootNode)
        rootNode.addChild(selectionExtentRoot)
        rootNode.addChild(selectionHiliteRoot)

        centerDotSprite = SKSpriteNode(imageNamed: "circle_100x100")
        centerDotSprite.size *= 0.5
        centerDotSprite.colorBlendFactor = 1
        centerDotSprite.color = .yellow
        centerDotSprite.isHidden = true
        centerDotSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        cameraNode.position = CGPoint.zero
        cameraNode.setScale(cameraScale)

        grid = Grid(size: GridSize(width: 5, height: 5), origin: .center, yAxis: .upIsPositive)

        gridView = GridView(
            scene: self, grid: grid,
            cellSizeInPixels: Self.cellSizeInPixels,
            camera: cameraNode, rootNode: rootNode
        )

        setupSelectionExtentSprites()
        setupSelectionHiliteSprites()
        setupDotSprites()

        (0..<grid.size.area()).forEach { ss in
            let cell = grid.cellAt(ss)
            let positionInScene = gridView.convertPointToScene(position: cell.gridPosition)

            selectionHiliteSprites[ss].position = positionInScene
            dotSprites[ss].position = positionInScene

            cell.contents = CCellContents(dotSprite: dotSprites[ss], selectionStageHiliteSprite: selectionHiliteSprites[ss])
        }

        selectionerView = SelectionerView(
            scene: self,
            selectionExtentRoot: selectionExtentRoot, selectionExtentSprites: selectionExtentSprites,
            selectionHiliteRoot: selectionHiliteRoot, selectionHiliteSprites: selectionHiliteSprites
        )

        redraw()
    }

    func drawRubberBand(from startVertex: CGPoint, to endVertex: CGPoint) {
        selectionerView.drawRubberBand(from: startVertex, to: endVertex)

        let startVertexInScene = convertPoint(fromView: startVertex)
        let endVertexInScene = convertPoint(fromView: endVertex)
        gridView.updateSelectionStagingHilite(from: startVertexInScene, to: endVertexInScene)

        selectionHiliteRoot.isHidden = gridView.selectionStageCells.isEmpty
    }

    func hideRubberBand() {
        selectionerView.reset()
    }

    func redraw() {
        gridView.showGridLines(showGridLines)
        redrawRequired = false
    }

    override func scrollWheel(with event: NSEvent) {
        setZoom(delta: -event.scrollingDeltaY * 0.1)
    }

    func setZoom(delta zoomDelta: CGFloat) {
        var newZoom = cameraNode.xScale + zoomDelta
        if newZoom < Self.MIN_ZOOM { newZoom = Self.MIN_ZOOM }
        else if newZoom > Self.MAX_ZOOM { newZoom = Self.MAX_ZOOM }

        cameraScale = newZoom
        cameraNode.setScale(cameraScale)
    }

    func tap(at positionInView: CGPoint) {
        let scenePoint = convertPoint(fromView: positionInView)
        let gridPoint = gridView.convertPointFromScene(position: scenePoint)

        guard grid.isOnGrid(gridPoint) else { return }

        let cell = grid.cellAt(gridPoint)
        let contents = cell.contents! as! CCellContents
        contents.dotSprite.isHidden = !contents.dotSprite.isHidden
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == -1 {
            lastUpdateTime = currentTime
        }

        defer { lastUpdateTime = currentTime }

        if redrawRequired {
            redraw()
        }
    }

    func updateForSelection() {
        gridView.selectionStageCells.forEach { cell in
            let contents = cell.contents! as! CCellContents
            contents.dotSprite.isHidden = !contents.dotSprite.isHidden
        }
    }
}

private extension CScene {
    func setupDotSprites() {
        self.dotSprites = (0..<grid.size.area()).map { _ in
            let sprite = SKSpriteNode(imageNamed: "circle_100x100")

            sprite.alpha = 1
            sprite.colorBlendFactor = 1
            sprite.color = .blue
            sprite.isHidden = true
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sprite.size = Self.cellSizeInPixels * 0.25

            rootNode.addChild(sprite)
            return sprite
        }
    }

    func setupSelectionExtentSprites() {
        self.selectionExtentSprites = SelectionerView.Directions.allCases.map { ss in
            let sprite = SKSpriteNode(imageNamed: "pixel_1x1")

            sprite.alpha = 0.7
            sprite.colorBlendFactor = 1
            sprite.color = .yellow
            sprite.isHidden = false
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sprite.size = CGSize(width: 1, height: 1)

            selectionExtentRoot.addChild(sprite)
            return sprite
        }
    }

    func setupSelectionHiliteSprites() {
        self.selectionHiliteSprites = (0..<grid.size.area()).map { _ in
            let sprite = SKSpriteNode(imageNamed: "pixel_1x1")

            sprite.alpha = 0.25
            sprite.colorBlendFactor = 1
            sprite.color = .green
            sprite.isHidden = true
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sprite.size = Self.cellSizeInPixels * 0.75

            selectionHiliteRoot.addChild(sprite)
            return sprite
        }
    }
}
