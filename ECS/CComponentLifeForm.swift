// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import GameplayKit
import SpriteKit

final class CComponentLifeForm: GKComponent {
    enum Directive {
        case beginLife, endLife, noChange
    }

    var directive = Directive.noChange
    var isAlive = false
    let sprite: SKSpriteNode

    init(_ sprite: SKSpriteNode) {
        self.sprite = sprite
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
