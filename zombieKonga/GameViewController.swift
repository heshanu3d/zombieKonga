//
//  GameViewController.swift
//  zombieKonga
//
//  Created by hs on 2018/12/18.
//  Copyright © 2018年 hs. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let skView = self.view as! SKView?
        {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: CGSize(width: 2048, height: 1536))
            scene.scaleMode = .aspectFill
            
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            skView.presentScene(scene)
        }
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
