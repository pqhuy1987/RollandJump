//
//  GameViewController.swift
//  Roll and Jump Beta 1
//
//  Created by Administrator on 10/19/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

import UIKit
import SpriteKit

//OLD CODE
/*
extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            //This line was errored after updating XCode to 6.1 so I replaced it with the line below it
            var sceneData = NSData.dataWithContentsOfMappedFile(path) //(path, options: .DataReadingMappedIfSafe, error: nil)
            
            
            
            
            //var sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}*/

extension SKNode {
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        guard let
            path = Bundle.main.path(forResource: file, ofType: "sks"),
            let sceneData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        
        guard let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? GameScene else {
            return nil
        }
        
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            
            let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.allButUpsideDown]
            return orientation
            
            
            
            //return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.all]
            return orientation
            
            //return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
