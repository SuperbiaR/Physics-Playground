import Foundation
import UIKit
import SpriteKit
 
class IntroScene: SKScene {
    // Objects
    let squareReference = SKSpriteNode(imageNamed: "Square?")
    let startGameButton = SKSpriteNode(imageNamed: "Start Button")
    let player = SKSpriteNode(imageNamed: "playerOBJ")
    let textLineFST = SKLabelNode(text: "START THE UNNAMED GAME")
    
    // CG
    public var buttonSize: CGSize = CGSize(width: 125, height: 100)
    
    override func didMove(to view: SKView) {
        let playerRadius = player.frame.width / 2.0

        startGameButton.name = "Play Game"
        startGameButton.size = buttonSize
        startGameButton.zPosition = 10
        addChild(startGameButton)

        textLineFST.position = CGPoint(x: 0, y: 200)
        textLineFST.fontColor = .black
        textLineFST.zPosition = 10
        addChild(textLineFST)

        player.physicsBody = SKPhysicsBody(circleOfRadius: playerRadius)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = true
        player.position = CGPoint(x: 0, y: 0)
        player.physicsBody?.restitution = 1
        player.physicsBody?.pinned = false
        player.physicsBody?.friction = 0
        player.zPosition = 1
        addChild(player)

        player.physicsBody?.applyForce(CGVector(dx: 5000, dy: Int.random(in: -1000...1000)))

        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [self]_ in
            player.physicsBody?.velocity = CGVector(dx: Int((player.physicsBody?.velocity.dx)!) * 5, dy: Int((player.physicsBody?.velocity.dy)!) * 5)
        }

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if (name == "Play Game") {
                removeAllChildren()
                view?.presentScene(SKScene(fileNamed: "GameScene"))
            }
        }
    }
}
