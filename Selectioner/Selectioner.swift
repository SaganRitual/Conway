// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import GameplayKit
import SwiftUI

protocol SelectionerState: GKState {
    init(scene: CScene)
}

class Selectioner: GKStateMachine, ObservableObject {
    var endVertex: CGPoint = .zero
    var startVertex: CGPoint = .zero

    init(scene: CScene) {
        super.init(states: [None(scene: scene), Dragging(scene: scene)])
        enter(None.self)
    }

    static func getDragVertices(_ stateMachine: GKStateMachine?) -> (startVertex: CGPoint, endVertex: CGPoint) {
        let myself = stateMachine as! Selectioner
        return (myself.startVertex, myself.endVertex)
    }

    override func canEnterState(_ stateClass: AnyClass) -> Bool {
        // We can enter rubber banding state from none state, but we can't re-enter rubber banding state
        if stateClass is Dragging.Type {
            return currentState! is None
        }

        return true
    }

    func dragging(startVertex: CGPoint, endVertex: CGPoint) {
        self.startVertex = startVertex
        self.endVertex = endVertex

        if startVertex == endVertex {
            enter(None.self)
        } else {
            enter(Dragging.self)
        }

        update(deltaTime: 0)
    }

    func notDragging() {
        enter(None.self)
        update(deltaTime: 0)
    }
}

extension Selectioner {
    final class None: GKState, SelectionerState {
        let scene: CScene

        init(scene: CScene) { self.scene = scene }

        override func didEnter(from previousState: GKState?) {
            // If it's nil then we're starting up and the scene won't be ready
            if previousState == nil { return }

            let ps = previousState! as! SelectionerState

            // If we're completing a drag, update all the applicable dots
            if !(ps is None) {
                scene.updateForSelection()
            }

            scene.hideRubberBand()
        }
    }

    final class Dragging: GKState, SelectionerState {
        let scene: CScene

        init(scene: CScene) { self.scene = scene }

        override func update(deltaTime: TimeInterval) {
            let (startVertex, endVertex) = Selectioner.getDragVertices(stateMachine)
            scene.drawRubberBand(from: startVertex, to: endVertex)
        }
    }
}
