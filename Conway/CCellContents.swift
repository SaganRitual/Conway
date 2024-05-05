// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

class CCellContents: GridCellContentsProtocol {
    let entity: CEntityGridCell
    let selectionHiliteSprite: SKSpriteNode

    init(dotSprite: SKSpriteNode, selectionHiliteSprite: SKSpriteNode) {
        self.entity = CEntityGridCell()
        entity.addComponent(CComponentLifeForm(dotSprite))

        self.selectionHiliteSprite = selectionHiliteSprite
    }
}
