//
//  GameOverScene.swift
//  Roll and Jump Beta 1
//
//  Created by Administrator on 11/2/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

//import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    //Create the game over logo
    let gameOverText = SKLabelNode(fontNamed: "BradleyHandITCTT-Bold")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //Center the game over in the frame and add it to the screen
        self.gameOverText.text = "Game Over!"
        self.gameOverText.fontSize = 42
        self.gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(self.gameOverText)
        
        //set the background color
        self.backgroundColor = UIColor(hex: 0x80D9ff)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch:AnyObject in touches {
            let location = touch.locationInNode(self)
            
            print("Go to the game.")
                
            //Go to the game
            var scene = GameScene(size: self.size)
            let skView = self.view as SKView!
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .ResizeFill
            scene.size = skView.bounds.size
            skView.presentScene(scene)
            }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        self.gameOverText.position.y -= 1
    }
}
