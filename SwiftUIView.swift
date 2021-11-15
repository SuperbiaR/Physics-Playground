import SwiftUI
import SpriteKit
import UIKit

class ButtonScene: SKScene {
    override func didMove(to view: SKView) {
        let button = SKSpriteNode(imageNamed: "playerOBJ")
        
        // Button
        button.name = "jamp"
        button.size.height = 100
        button.size.width = 100
        button.position = CGPoint(x: 100, y: 500)
        self.addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

        if let name = touchedNode.name {
            if name == "jamp" {
                fatalError()
            }
        }
    }
}






