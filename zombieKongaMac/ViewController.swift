//
//  ViewController.swift
//  zombieKongaMac
//
//  Created by hs on 2018/12/20.
//  Copyright © 2018年 hs. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {
    
    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: CGSize(width: 2048, height: 1536))
                scene.scaleMode = .aspectFit
                view.presentScene(scene)
            
            //            if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            //                scene.scaleMode = .aspectFill
            
            // Present the scene
            //                view.presentScene(scene)
            //            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

