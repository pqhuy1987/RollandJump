//
//  PlayScene.swift
//  Roll and Jump Beta 1
//
//  Created by Administrator on 10/19/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//
//  This is where all the game play takes place
import SpriteKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    //Create our object images
    let runningBar = SKSpriteNode(imageNamed: "bar")
    let hero = SKSpriteNode(imageNamed: "hero")
    let block1 = SKSpriteNode(imageNamed: "block1")
    let block2 = SKSpriteNode(imageNamed: "block2")
    let scoreText = SKLabelNode(fontNamed: "ChalkDuster")
    let livesText = SKLabelNode(fontNamed: "ChalkDuster")
    let fireball = SKSpriteNode(imageNamed: "fireball")
    
    var origRunningBarPositionX = CGFloat(0)
    var maxBarX = CGFloat(0)
    var groundSpeed = 5
    var heroBaseline = CGFloat(0)
    var onGround = true
    var velocityY = CGFloat(0)
    let gravity = CGFloat(0.6)
    
    var blockMaxX = CGFloat(0)
    var origBlockPositionX = CGFloat(0)
    var score = 0
    var lives = 3
    
    enum ColliderType:UInt32 {
        case hero = 1
        case block = 2
    }
    
    //This function loads when the PlayScene view has been presented
    override func didMove(to view: SKView) {
        print("didMoveToView - We are at the new scene.")
        self.backgroundColor = UIColor(hex:0x80D9ff)
        
        self.physicsWorld.contactDelegate = self
        
        self.runningBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.runningBar.position = CGPoint(x: self.frame.minX, y: self.frame.minY + (self.runningBar.size.height / 2))
        
        
        self.origRunningBarPositionX = self.runningBar.position.x
        self.maxBarX = self.runningBar.size.width - self.frame.size.width
        self.maxBarX *= -1
        
        self.heroBaseline = self.runningBar.position.y + (self.runningBar.size.height / 2) + (self.hero.size.height / 2)
        self.hero.position = CGPoint(x: self.frame.minX + self.hero.size.width + self.hero.size.width / 4, y: self.heroBaseline)
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.hero.size.width / 2))
        self.hero.physicsBody?.affectedByGravity = false
        self.hero.physicsBody?.categoryBitMask = ColliderType.hero.rawValue
        self.hero.physicsBody?.contactTestBitMask = ColliderType.block.rawValue
        self.hero.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        
        
        self.block1.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseline)
        self.block2.position = CGPoint(x: self.frame.maxX + self.block2.size.width, y: self.heroBaseline + self.block1.size.height / 2)
        self.block1.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.block1.physicsBody?.isDynamic = false
        self.block1.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.block1.physicsBody?.contactTestBitMask = ColliderType.hero.rawValue
        self.block1.physicsBody?.collisionBitMask = ColliderType.hero.rawValue
        
        self.block2.physicsBody = SKPhysicsBody(rectangleOf: self.block2.size)
        self.block2.physicsBody?.isDynamic = false
        self.block2.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.block2.physicsBody?.contactTestBitMask = ColliderType.hero.rawValue
        self.block2.physicsBody?.collisionBitMask = ColliderType.hero.rawValue
        
        self.fireball.position = CGPoint(x: self.frame.maxX + self.fireball.size.width, y: self.frame.maxY - self.fireball.size.height)
        self.fireball.physicsBody = SKPhysicsBody(rectangleOf: self.fireball.size)
        self.fireball.physicsBody?.isDynamic = false
        //self.fireball.physicsBody?.categoryBitMask = ColliderType.
        
        self.origBlockPositionX = self.block1.position.x
        
        self.block1.name = "block1"
        self.block2.name = "block2"
        self.fireball.name = "fireball"
        
        blockStatuses["block1"] = BlockStatus(isRunning: false, timeGapForNextRun: random(), currentInterval: UInt32(0))
        blockStatuses["block2"] = BlockStatus(isRunning: false, timeGapForNextRun: random(), currentInterval: UInt32(0))
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.livesText.text = "3" + " Lives"
        self.livesText.fontSize = 42
        self.livesText.position = CGPoint(x: self.frame.minX + (self.frame.size.width / 2), y: self.frame.minY + (self.runningBar.size.height/2))
        
        self.blockMaxX = 0 - self.block1.size.width / 2
        
        self.addChild(self.runningBar)
        self.addChild(self.hero)
        self.addChild(self.block1)
        self.addChild(self.block2)
        self.addChild(self.scoreText)
        self.addChild(self.livesText)
        self.addChild(self.fireball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        self.lives -= 1
        self.livesText.text = String(self.lives) + " Lives"
        if (self.lives <= 0) {
            died()
        }
        
        //contact.bodyA.categoryBitMask == ColliderType.Hero.rawValue
        
    }
    
    func died() {
            print("Go to the Game Over screen")
            
            //Go to the game
            let scene = GameOverScene(size: self.size)
            let skView = self.view as SKView!
            skView?.ignoresSiblingOrder = true
            scene.scaleMode = .resizeFill
            scene.size = (skView?.bounds.size)!
            skView?.presentScene(scene)
    }
    
    
    func random() -> UInt32 {
        let range = UInt32(50)..<UInt32(200)
        return range.lowerBound + arc4random_uniform(range.upperBound - range.lowerBound + 1)
    }
    
    var blockStatuses:Dictionary<String, BlockStatus> = [:]
    
    //override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if self.onGround {
            self.velocityY = -18
            self.onGround = false
        }
    }
    
    //override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if self.velocityY < -9.0 {
            self.velocityY = -9.0
        }
    }
    
    //This function runs on every single screen update
    override func update(_ currentTime: TimeInterval) {
        if self.runningBar.position.x <= maxBarX {
            self.runningBar.position.x = self.origRunningBarPositionX
        }
        
        //jump
        self.velocityY += self.gravity
        self.hero.position.y -= velocityY
        
        if self.hero.position.y < self.heroBaseline {
            self.hero.position.y = self.heroBaseline
            velocityY = 0.0
            self.onGround = true
        }
        
        //if the hero moves off the screen
        if self.hero.position.x < 0 {
            died()
        }
        
        //rotate the hero
        let degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
        
        //rotate the hero
        self.hero.zRotation -= CGFloat(degreeRotation)
        
        //move the ground
        runningBar.position.x -= CGFloat(self.groundSpeed)
        
        blockRunner()
        
    }
    
    func blockRunner() {
        for (block, blockStatus) in self.blockStatuses {
            let thisBlock = self.childNode(withName: block)
            if blockStatus.shouldRunBlock() {
                blockStatus.timeGapForNextRun = random()
                blockStatus.currentInterval = 0
                blockStatus.isRunning = true
            }
            
            if blockStatus.isRunning {
                if thisBlock?.position.x > blockMaxX {
                    thisBlock?.position.x -= CGFloat(self.groundSpeed)
                } else {
                    thisBlock?.position.x = self.origBlockPositionX
                    blockStatus.isRunning = false
                    self.score += 1
                    if ((self.score % 5) == 0) {
                        self.groundSpeed += 1
                    }
                    self.scoreText.text = String(self.score)
                }
            }else {
                blockStatus.currentInterval += 1
            }
        }
    }
}
