//
//  GameScene.swift
//  zombieKonga
//
//  Created by hs on 2018/12/18.
//  Copyright © 2018年 hs. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    var dt: TimeInterval = 0
    var zombieMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint(x: 0, y: 0)
    let playableRect: CGRect
    
    
    let cat1 = SKSpriteNode(imageNamed: "cat")
    let cat2 = SKSpriteNode(imageNamed: "cat")
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.white
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        cat1.position = CGPoint(x: size.width / 8, y: size.height / 2)
        cat1.zPosition = 0
        addChild(cat1)
        
        cat2.position = CGPoint(x: size.width / 8 * 3, y: size.height / 2)
        cat2.zPosition = 0
        addChild(cat2)
        
        zombie.position = CGPoint(x: size.width / 8, y: size.height / 4)
        zombie.zPosition = 0
        addChild(zombie)
        
        debugDrawPlayableArea()
    }
    
    override init(size: CGSize)
    {
        let maxAspectRatio:CGFloat = 16.0/9.0
        // 1
        let playableHeight = size.width / maxAspectRatio
        // 2
        let playableMargin = (size.height-playableHeight)/2.0
        // 3
        playableRect = CGRect(x: 0, y: playableMargin,width: size.width,height: playableHeight)
        // 4
        super.init(size: size)
        // 5
    }
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        // 6
    }
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint)
    {
        // 1
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity.y * CGFloat(dt))
//        print("Amount to move: \(amountToMove)")
        // 2
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x,
                                  y: sprite.position.y + amountToMove.y)
        
    }
    
    func moveZombieToward(sprite: SKSpriteNode, location: CGPoint)
    {
        let offset = CGPoint(x: location.x - sprite.position.x,
                             y: location.y - sprite.position.y)
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * zombieMovePointsPerSec, y: direction.y * zombieMovePointsPerSec)
    }
    
    func boundsCheckZombie()
    {
//        let bottomLeft = CGPoint(x: 0, y: 0)
//        let topRight = CGPoint(x: size.width, y: size.height)
        let bottomLeft = CGPoint(x: 0,
                                 y: playableRect.minY)
        let topRight = CGPoint(x: size.width,
                               y: playableRect.maxY)
        if zombie.position.x <= bottomLeft.x
        {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if zombie.position.x >= topRight.x
        {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if zombie.position.y <= bottomLeft.y
        {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if zombie.position.y >= topRight.y
        {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    func debugDrawPlayableArea()
    {
        let shape = SKShapeNode()
        let path = CGMutablePath.init()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint)
    {
        sprite.zRotation = CGFloat(atan2(Double(direction.y),
                                         Double(direction.x)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //        if let label = self.label {
        //            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //        }
        
        //        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        let touch = touches.first
        if(touch != nil)
        {
            moveZombieToward(sprite: zombie, location: touch!.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        let touch = touches.first
        if(touch != nil)
        {
            moveZombieToward(sprite: zombie, location: touch!.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        dt = 1 / 60
        //moveSprite(sprite: zombie, velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
        moveSprite(sprite: zombie, velocity: velocity)
        rotateSprite(sprite: zombie, direction: velocity)
        
    }
}
