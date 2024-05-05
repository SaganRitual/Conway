// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

class CCellContents: GridCellContentsProtocol {
    var dotSprite: SKSpriteNode
    var selectionStageHiliteSprite: SKSpriteNode

    init(dotSprite: SKSpriteNode, selectionStageHiliteSprite: SKSpriteNode) {
        self.dotSprite = dotSprite
        self.selectionStageHiliteSprite = selectionStageHiliteSprite
    }
}
