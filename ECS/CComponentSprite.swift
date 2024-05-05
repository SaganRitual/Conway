// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import GameplayKit
import SpriteKit

final class CComponentSprite: GKComponent {
    let sprite: SKSpriteNode

    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
