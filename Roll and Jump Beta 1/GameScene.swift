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
    let playButton = SKSpriteNode(imageNamed: "Play")
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        //Center the play button in the frame and add it to the screen
        self.playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(self.playButton)
        
        //set the background color
        self.backgroundColor = UIColor(hex: 0x80D9ff)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch:AnyObject in touches {
            let location = touch.location(in: self)
            //If the play button was pressed
            if self.atPoint(location) == self.playButton {
                print("Go to the game.")
                
                //Go to the game
                let scene = PlayScene(size: self.size)
                let skView = self.view as SKView!
                skView?.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = (skView?.bounds.size)!
                skView?.presentScene(scene)
            }
            
        }
     
        
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
