//
//  GameScene.swift
//  Roll and Jump Beta 1
//
//  Created by Administrator on 10/19/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//
//  This is the home screen with the Play button

import SpriteKit

class GameScene: SKScene {
    
    //Create the Play button
    let playButton = SKSpriteNode(imageNamed: "play")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //Center the play button in the frame and add it to the screen
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(self.playButton)
        
        //set the background color
        self.backgroundColor = UIColor(hex: 0x80D9ff)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch:AnyObject in touches {
            let location = touch.locationInNode(self)
            //If the play button was pressed
            if self.nodeAtPoint(location) == self.playButton {
                print("Go to the game.")
                
                //Go to the game
                var scene = PlayScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
            
        }
     
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
