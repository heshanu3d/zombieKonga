//
//  MainMenuScene.swift
//  zombieKonga
//
//  Created by hs on 2018/12/19.
//  Copyright © 2018年 hs. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    override init(size: CGSize) {
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode.init(imageNamed: "MainMenu")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.fontSize = 100
        label.name = "welcomeLabel"
        label.text = "Tap Anywhere"
        label.position = CGPoint(x: size.width / 2, y: size.height / 3)
//        let fadeAction = SKAction.fadeAlpha(by: 0, duration: 1)
//        let waitAction = SKAction.wait(forDuration: 0.3)
        addChild(label)
        
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration, actionBlock: { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        })

        label.run(blinkAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = GameScene(size: size)
        let transion = SKTransition.doorway(withDuration: 1.5)
        scene.scaleMode = scaleMode
        view?.presentScene(scene, transition: transion)
    }
}
