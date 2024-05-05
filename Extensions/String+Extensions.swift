// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

extension String {
    func padLeft(targetLength: Int, padCharacter: String = " ") -> String {
        guard targetLength > count else { return self }

        return String(repeating: padCharacter, count: targetLength - count) + self
    }
}

extension CGSize: CustomStringConvertible {
    public var description: String {
        String(format: "%.2f", width) + " x " + String(format: "%.2f", height)
    }
}

func getMousePositionString(positionInView: CGPoint) -> String {
    let vx = String(format: "%.2f", positionInView.x)
    let vy = String(format: "%.2f", positionInView.y)

    return "(\(vx), \(vy))"
}

func getMousePositionString(forScene scene: CScene, positionInView: CGPoint) -> String {
    let positionInScene = scene.convertPoint(fromView: positionInView)
    let sx = String(format: "%.2f", positionInScene.x)
    let sy = String(format: "%.2f", positionInScene.y)

    return "(\(sx), \(sy))"
}

func getMousePositionStringForGrid(scene: CScene, positionInView: CGPoint) -> String {
    let positionInScene = scene.convertPoint(fromView: positionInView)

    let positionInGrid = scene.gridView.convertPointFromScene(position: positionInScene)
    guard scene.grid.isOnGrid(positionInGrid) else {
        return "Out of bounds"
    }

    let gx = String(format: "%d", positionInGrid.x)
    let gy = String(format: "%d", positionInGrid.y)

    return "(\(gx), \(gy))"
}
