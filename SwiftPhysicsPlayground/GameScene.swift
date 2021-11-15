import SwiftUI
import SpriteKit
import UIKit

class GameScene: SKScene {
    // Object Defining Jesus theres a lot of this
    let player = SKSpriteNode(imageNamed: "playerOBJ")
    let buttonL = SKSpriteNode(imageNamed: "buttonOBJ")
    let buttonR = SKSpriteNode(imageNamed: "buttonOBJ")
    let buttonJUMP = SKSpriteNode(imageNamed: "buttonOBJ")
    let buttonSTOP = SKSpriteNode(imageNamed: "buttonOBJ")
    let buttonBounce = SKSpriteNode(imageNamed: "buttonOBJ")
    let pinned = SKSpriteNode(imageNamed: "playerOBJ")
    let slopeL = SKSpriteNode(imageNamed: "slopeL")
    let slopeR = SKSpriteNode(imageNamed: "slopeR")
    let backdrop = SKSpriteNode(color: .gray, size: CGSize(width: 1000, height: 200))
    let backdropRim = SKSpriteNode(color: .black, size: CGSize(width: 1000, height: 10))
    let textL = SKLabelNode(text: "LEFT: FALSE")
    let textR = SKLabelNode(text: "RIGHT: FALSE")
    let textJ = SKLabelNode(text: "JUMP")
    let textS = SKLabelNode(text: "STOP")
    let textBounce = SKLabelNode(text: "BOUNCE AMOUNT: 0.0")

    // Booleans
    public var movingLeft: Bool = false {
        didSet {
            textL.text = "LEFT: \(String(movingLeft).uppercased())"
            
        }
    }
    public var movingRight: Bool = false {
        didSet {
            textR.text = "RIGHT: \(String(movingRight).uppercased())"
            
        }
    }
    
    // CG
    public var buttonSize: CGSize = CGSize(width: 100, height: 100)
    public let buttonHeightPOS: CGFloat = 140
    public var bouncyLevel: CGFloat = 0 {
        didSet {
            textBounce.text = "BOUNCE LEVEL: \(bouncyLevel)"
            player.physicsBody?.restitution = bouncyLevel
            
        }
    }
    
    // Integers
    public var jumpForce: Int = 3000
    
    override func didMove(to view: SKView) {
        // Backdrop
        backdrop.position = CGPoint(x: 425, y: 100)
        backdropRim.position = CGPoint(x: 425, y: 200)
        backdropRim.zPosition = 100
        addChild(backdropRim)
        addChild(backdrop)
        
        pinned.physicsBody = SKPhysicsBody(texture: pinned.texture!, size: pinned.size)
        pinned.position = CGPoint(x: 320, y: 320)
        pinned.zRotation = CGFloat.pi / 2
        pinned.physicsBody?.pinned = true
        addChild(pinned)
        
        slopeL.position = CGPoint(x: 40, y: 245)
        slopeL.physicsBody = SKPhysicsBody(texture: slopeL.texture!, size: slopeL.size)
        slopeL.physicsBody!.pinned = true
        slopeL.physicsBody!.allowsRotation = false
        addChild(slopeL)
        
        slopeR.position = CGPoint(x: 790, y: 245)
        slopeR.physicsBody = SKPhysicsBody(texture: slopeR.texture!, size: slopeR.size)
        slopeR.physicsBody!.pinned = true
        slopeR.physicsBody!.allowsRotation = false
        addChild(slopeR)
        
        let playerRadius = player.frame.width / 2.0
        player.physicsBody = SKPhysicsBody(circleOfRadius: playerRadius)
        player.physicsBody?.restitution = bouncyLevel
        player.physicsBody?.allowsRotation = true
        player.position = CGPoint(x: 200, y: 500)
        player.physicsBody?.pinned = false
        player.physicsBody?.friction = 0
        player.zPosition = 100
        player.name = "Jimmy"
        addChild(player)
        
        // Button Left
        buttonL.name = "Left"
        buttonL.size = buttonSize
        buttonL.position = CGPoint(x: 100, y: buttonHeightPOS)
        textL.position = CGPoint(x: buttonL.position.x, y: buttonHeightPOS - 100)
        textL.fontColor = .black
        self.addChild(buttonL)
        self.addChild(textL)
        
        // Button Right
        buttonR.name = "Right"
        buttonR.size = buttonSize
        buttonR.position = CGPoint(x: 740, y: buttonHeightPOS)
        textR.position = CGPoint(x: buttonR.position.x, y: buttonHeightPOS - 100)
        textR.fontColor = .black
        self.addChild(buttonR)
        self.addChild(textR)
        
        // Jump Button
        buttonJUMP.name = "Jump"
        buttonJUMP.size = buttonSize
        buttonJUMP.position = CGPoint(x: (buttonR.position.x + buttonL.position.x)/2 - 70, y: buttonHeightPOS)
        textJ.position = CGPoint(x: buttonJUMP.position.x, y: buttonHeightPOS - 100)
        textJ.fontColor = .black
        self.addChild(buttonJUMP)
        self.addChild(textJ)
        
        // Stop Button
        buttonSTOP.name = "Stop"
        buttonSTOP.size = buttonSize
        buttonSTOP.position = CGPoint(x: (buttonR.position.x + buttonL.position.x)/2 + 70, y: buttonHeightPOS)
        textS.position = CGPoint(x: buttonSTOP.position.x, y: buttonHeightPOS - 100)
        textS.fontColor = .black
        self.addChild(buttonSTOP)
        self.addChild(textS)
        
        // Bounce Change Button
        buttonBounce.name = "Bounce"
        buttonBounce.size = CGSize(width: 50, height: 50)
        buttonBounce.position = CGPoint(x: (buttonR.position.x + buttonL.position.x)/2, y: 1150)
        textBounce.position = CGPoint(x: buttonBounce.position.x, y: buttonBounce.position.y - 50)
        self.addChild(buttonBounce)
        self.addChild(textBounce)

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: 200, left: 0, bottom: 100, right: 0)))
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [self] timer in
            print(player.physicsBody?.velocity as Any)
            
            if (movingLeft == true) {
                player.physicsBody?.applyForce(CGVector(dx: -200, dy: 0))
                
            }
            
            if (movingRight == true) {
                player.physicsBody?.applyForce(CGVector(dx: 200, dy: 0))
                
            }
            
            if (player.position.y < -300) {
                removeAllChildren()
                let viewSize = CGRect(x: 0, y: 0, width: 00, height: 00)
                didMove(to: SKView(frame: viewSize))
                
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "Left" {
                movingLeft.toggle()
                print("Left: \(movingLeft)")
                
            } else if name == "Right" {
                movingRight.toggle()
                print("Right: \(movingRight)")
                
            } else if name == "Jump" {
                player.physicsBody?.applyForce(CGVector(dx: 0, dy: jumpForce))
                
            } else if name == "Stop" {
                player.physicsBody?.pinned.toggle()
                
            } else if name == "Bounce" {
                if(bouncyLevel == 0.0) {
                    bouncyLevel = 0.2
                    
                } else if (bouncyLevel == 0.2) {
                    bouncyLevel = 0.5
                
                } else if (bouncyLevel == 0.5) {
                    bouncyLevel = 1.0
                
                } else {
                    bouncyLevel = 0.0
                
                }
            }
        }
    }
}
