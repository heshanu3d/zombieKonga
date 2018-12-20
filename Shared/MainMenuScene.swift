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
    let debugLayer = SKNode()
    let label = SKLabelNode(fontNamed: "Chalkduster")
    let labelInLayer = SKLabelNode(fontNamed: "Chalkduster")
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
        
        
        label.fontSize = 100
        label.name = "welcomeLabel"
        label.text = "Tap Anywhere"
        label.position = CGPoint(x: size.width / 2, y: size.height / 3)
        label.zPosition = 1
        addChild(label)
        
        //debug for coordinate convert
        debugLayer.zPosition = 0
        
        labelInLayer.fontSize = 100
        labelInLayer.name = "Label in layer"
        labelInLayer.text = "Label in the layer"
        labelInLayer.position = CGPoint(x: size.width / 2, y: size.height / 3 * 2)
        
        debugLayer.addChild(labelInLayer)
//        debugLayer.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        debugLayer.addChild(background)
//        debugLayer.addChild(label)
        addChild(debugLayer)
        
        
        
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration, actionBlock: { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        })

        label.run(blinkAction)
    }
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = GameScene(size: size)
        let transion = SKTransition.doorway(withDuration: 1.5)
        scene.scaleMode = scaleMode
        view?.presentScene(scene, transition: transion)
    }
    #else
    override func mouseDown(with event: NSEvent) {
        let scene = GameScene(size: size)
        let transion = SKTransition.doorway(withDuration: 1.5)
        scene.scaleMode = scaleMode
        view?.presentScene(scene, transition: transion)
    }
    #endif
    
    override func update(_ currentTime: TimeInterval) {
        debugLayer.position += CGPoint(x: 1, y: 0)
//        print("label in scene:\(label.position)")
//        print("label in layer:\(debugLayer.convert(labelInLayer.position, to: self))")
    }
}
