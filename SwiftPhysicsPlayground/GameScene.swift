import SwiftUI
import SpriteKit
import UIKit

class pinnedOBJ: SKSpriteNode { }

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Object Defining Jesus theres a lot of this
    let player = SKSpriteNode(imageNamed: "playerOBJ")
    let buttonL = SKSpriteNode(imageNamed: "buttonOBJ")
    let buttonR = SKSpriteNode(imageNamed: "buttonOBJ")
    let buttonJUMP = SKSpriteNode(imageNamed: "buttonOBJ")
    let buttonSTOP = SKSpriteNode(imageNamed: "buttonOBJ")
    let buttonBounce = SKSpriteNode(imageNamed: "buttonOBJ")
    let buttonPuffToggle = SKSpriteNode(imageNamed: "buttonOBJ")
    let pinned = SKSpriteNode(imageNamed: "playerOBJ")
    let slopeL = SKSpriteNode(imageNamed: "slopeL")
    let slopeR = SKSpriteNode(imageNamed: "slopeR")
    let puff = SKSpriteNode(imageNamed: "puff?")
    let backdrop = SKSpriteNode(color: .gray, size: CGSize(width: 1000, height: 200))
    let backdropRim = SKSpriteNode(color: .black, size: CGSize(width: 1000, height: 10))
    let textL = SKLabelNode(text: "LEFT: FALSE")
    let textR = SKLabelNode(text: "RIGHT: FALSE")
    let textJ = SKLabelNode(text: "JUMP")
    let textS = SKLabelNode(text: "STOP")
    let textP = SKLabelNode(text: "PUFF TOGGLE")
    let textBounce = SKLabelNode(text: "BOUNCE AMOUNT: 0.0")
    let logicNode = SKNode()
    
    
    // SKActions
    let audioDead = SKAction.playSoundFileNamed("Scout_paincrticialdeath02", waitForCompletion: false)
    
    
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
    public var stop: Bool = false
    public var brake: Bool = false
    public var ispuff: Bool = false
    public var puffexists: Bool = true
    
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
    public var moveSpeed: Int = 300
    public var puffAutoMove: Int = 20
    public var loomingThreatLevel: Int = 0
    public var bumperAmount: Int = 10 {
        didSet {
            resetAll()
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Backdrop
        backdrop.position = CGPoint(x: 425, y: 100)
        backdropRim.position = CGPoint(x: 425, y: 200)
        backdropRim.zPosition = 100
        addChild(backdropRim)
        addChild(backdrop)
        
        
        for _ in 1...bumperAmount {
            let bumper = pinnedOBJ(imageNamed: "playerOBJ")
            bumper.physicsBody = SKPhysicsBody(texture: pinned.texture!, size: pinned.size)
            bumper.position = CGPoint(x: 320, y: 600)
            bumper.zRotation = CGFloat.pi / 2
            bumper.physicsBody?.pinned = false
            bumper.physicsBody?.restitution = 1
            addChild(bumper)
            bumper.physicsBody?.applyForce(CGVector(dx: Int.random(in: -10000...10000), dy: Int.random(in: -1000...1000)))
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                bumper.physicsBody?.pinned.toggle()
                
            }
        }
        
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
        
        
        // Puff????
        // yes
        // k
        let puffRadius = puff.frame.width / 2.0
        puff.physicsBody = SKPhysicsBody(circleOfRadius: puffRadius)
        puff.physicsBody?.restitution = 1
        puff.physicsBody?.allowsRotation = true
        puff.position = CGPoint(x: 500, y: 900)
        puff.physicsBody?.affectedByGravity = false
        puff.zPosition = 1000
        puff.name = "puff"
        addChild(puff)
        
        
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
        buttonBounce.position = CGPoint(x: (buttonR.position.x + buttonL.position.x)/2 + 150, y: 1150)
        textBounce.position = CGPoint(x: buttonBounce.position.x, y: buttonBounce.position.y - 50)
        textBounce.fontColor = .white
        self.addChild(buttonBounce)
        self.addChild(textBounce)
        
        // Puff Toggle Button
        buttonPuffToggle.name = "Puff Toggle"
        buttonPuffToggle.size = CGSize(width: 50, height: 50)
        buttonPuffToggle.position = CGPoint(x: (buttonR.position.x + buttonL.position.x)/2 - 150, y: 1150)
        textP.position = CGPoint(x: buttonPuffToggle.position.x, y: buttonPuffToggle.position.y - 50)
        textP.fontColor = .systemPink
        self.addChild(buttonPuffToggle)
        self.addChild(textP)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: 200, left: 0, bottom: 100, right: 0)))
        
        
        // Movement Cause I Can
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in
            print("Player Velocity:")
            print(player.physicsBody?.velocity as Any)
            
            
            print("Puff Position")
            
            
            if puff.parent == nil {
                print("Puff Is Not Here")
                
            } else {
                print(puff.physicsBody?.velocity as Any)
                
            }
            
            
            if (movingLeft == true) {
                if (Int((player.physicsBody?.velocity.dx)!) > -moveSpeed) {
                    player.physicsBody?.applyForce(CGVector(dx: -moveSpeed - Int((player.physicsBody?.velocity.dx)!), dy: 0))
                    
                }
                
                
            }
            
            if (movingRight == true) {
                if (Int((player.physicsBody?.velocity.dx)!) < moveSpeed) {
                    player.physicsBody?.applyForce(CGVector(dx: moveSpeed - Int((player.physicsBody?.velocity.dx)!), dy: 0))
                    
                }
                
            }
            
            if (player.position.y < -300) {
                resetAll()
                
            }
            
            if (brake == true) {
                if (Double((player.physicsBody?.velocity.dx)!) < 1) {
                    player.physicsBody?.applyForce(CGVector(dx: 100, dy: 0))
                    
                } else if (Double((player.physicsBody?.velocity.dx)!) > -1) {
                    player.physicsBody?.applyForce(CGVector(dx: -100, dy: 0))
                    
                }
            }
            
            if puffexists {
                // Dont crash
                if (Int(puff.position.y) < 700) {
                    puff.physicsBody?.velocity = CGVector(dx: (puff.physicsBody?.velocity.dx)!, dy: -((puff.physicsBody?.velocity.dy)!))
                }
                if (/* Greater then -20 */ (Int(puff.physicsBody!.velocity.dx) > -puffAutoMove) && (Int(puff.physicsBody!.velocity.dy) > -puffAutoMove) && /* Less then 20 */ (Int(puff.physicsBody!.velocity.dx) < puffAutoMove) && (Int(puff.physicsBody!.velocity.dy) < puffAutoMove)) {
                    
                    Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
                        if (/* Greater then -20 */ (Int(puff.physicsBody!.velocity.dx) > -puffAutoMove) && (Int(puff.physicsBody!.velocity.dy) > -puffAutoMove) && /* Less then 20 */ (Int(puff.physicsBody!.velocity.dx) < puffAutoMove) && (Int(puff.physicsBody!.velocity.dy) < puffAutoMove)) {
                            puff.physicsBody?.applyForce(CGVector(dx: Int.random(in: -1000...1000), dy: Int.random(in: -1000...1000)))
                            
                        }
                    }
                }
                
            } else {
                while true {
                    // Scream
                    print("AHHHHHHHHHHHH")
                    
                }
            }
        }
    }
    
    func playSound(sound : SKAction) {
        run(sound)
        
    }
    
    func resetAll() {
        removeAllChildren()
        let viewSize = CGRect(x: 0, y: 0, width: 00, height: 00)
        didMove(to: SKView(frame: viewSize))
        
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
                brake.toggle()
                
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
                
            } else if name == "Puff Toggle"{
                if (puff.parent != nil) {
                    puff.removeFromParent()
                    playSound(sound: audioDead)
                    
                } else {
                    self.addChild(puff)
                    
                }
            }
        }
    }
}
