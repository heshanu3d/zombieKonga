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
    var trainMovePointsPerSec: CGFloat = 360.0
    var zombieRotateRadiansPerSec:CGFloat = 4.0 * π
    var lastTouchPosition = CGPoint(x: 0, y: 0)
    var velocity = CGPoint(x: 0, y: 0)
    var invinsible : Bool = false
    
    let playableRect: CGRect
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    let zombieAnimation: SKAction
    let catCollisionSound : SKAction = SKAction.playSoundFileNamed("hitCat", waitForCompletion: false)
    let enemyCollisionSound : SKAction = SKAction.playSoundFileNamed("hitCatLady", waitForCompletion: false)
    let backgroundMusicAction : SKAction
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.white
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        zombie.position = CGPoint(x: size.width / 8, y: size.height / 4)
        zombie.zPosition = 0
        addChild(zombie)
        
        debugDrawPlayableArea()
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnEnemy),
                                                      SKAction.wait(forDuration: Double(0.5))])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnCat),
                                                      SKAction.wait(forDuration: Double(0.5 + CGFloat.random()))])))
        run(SKAction.repeatForever(backgroundMusicAction))
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
        var textures : [SKTexture] = []
//        for i in 1...4 {
//            textures.append(SKTexture(imageNamed: "zombie\(i)"))
//        }
        textures.append(SKTexture(imageNamed: "zombie1"))
        textures.append(SKTexture(imageNamed: "zombie2"))
        textures.append(SKTexture(imageNamed: "zombie3"))
        textures.append(SKTexture(imageNamed: "zombie4"))
        textures.append(textures[2])
        textures.append(textures[1])
        zombieAnimation = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
//        zombieAnimation = SKAction.repeatForever(SKAction.animate(withNormalTextures: textures, timePerFrame: 0.1))//This mothed has no effect,use method above
        backgroundMusicAction = SKAction.playSoundFileNamed("backgroundMusic.mp3", waitForCompletion: true)
        super.init(size: size)

    }
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        // 6
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint)
    {
//        // 1
//        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
//                                   y: velocity.y * CGFloat(dt))
//        print("Amount to move: \(amountToMove)")
//        // 2
//        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x,
//                                  y: sprite.position.y + amountToMove.y)
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    
    func moveZombieToward(sprite: SKSpriteNode, location: CGPoint)
    {
//        let offset = CGPoint(x: location.x - sprite.position.x,
//                             y: location.y - sprite.position.y)
//        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
//        let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
//        velocity = CGPoint(x: direction.x * zombieMovePointsPerSec, y: direction.y * zombieMovePointsPerSec)
        startZombieAnimation()
        let offset = location - sprite.position
        velocity = offset.normalized() * zombieMovePointsPerSec
    }
    
    func boundsCheckZombie(sprite: SKSpriteNode)
    {
//        let bottomLeft = CGPoint(x: 0, y: 0)
//        let topRight = CGPoint(x: size.width, y: size.height)
        let bottomLeft = CGPoint(x: 0,
                                 y: playableRect.minY)
        let topRight = CGPoint(x: size.width,
                               y: playableRect.maxY)
//        let spW2R = sprite.size.width / 2
//        let spH2R = sprite.size.height / 2
        if zombie.position.x <= bottomLeft.x// + spW2R
        {
            zombie.position.x = bottomLeft.x// + spW2R
            velocity.x = -velocity.x
        }
        if zombie.position.x >= topRight.x// - spW2R
        {
            zombie.position.x = topRight.x// - spW2R
            velocity.x = -velocity.x
        }
        if zombie.position.y <= bottomLeft.y// + spH2R
        {
            zombie.position.y = bottomLeft.y// + spH2R
            velocity.y = -velocity.y
        }
        if zombie.position.y >= topRight.y// - spH2R
        {
            zombie.position.y = topRight.y// - spH2R
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
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat)
    {
        let angleBet = shortestAngleBetween(angle1: sprite.zRotation,angle2: direction.angle)
        if angleBet >= CGFloat(dt) * rotateRadiansPerSec * 0.5
        {
            sprite.zRotation += CGFloat(dt) * rotateRadiansPerSec
        }
        else if angleBet < -1 * CGFloat(dt) * rotateRadiansPerSec * 0.5
        {
            sprite.zRotation -= CGFloat(dt) * rotateRadiansPerSec
        }
    }
    
//    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint)
//    {
//        sprite.zRotation = CGFloat(atan2(Double(direction.y),
//                                         Double(direction.x)))
//    }
    
    func calDistanceBetTouchAndSprite(sprite: SKSpriteNode) -> Bool
    {
        let distancePos = sprite.position - lastTouchPosition
        let distance = distancePos.length()
        if distance <= CGFloat(dt) * 1.5 * zombieMovePointsPerSec
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func spawnEnemy()
    {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "enemy"
//        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: CGFloat.random(min: playableRect.minY + enemy.size.height / 2,
//                                                                                       max: playableRect.maxY - enemy.size.height / 2))
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: size.height / 2)
        addChild(enemy)
        
        let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width/2, y: enemy.position.y), duration: Double(0.5 + CGFloat.random()))
//        enemy.run(actionMove)
        
        // 1
//        let actionMidMove = SKAction.move(to: CGPoint(x: size.width/2,
//                                                      y: (playableRect.minY) + enemy.size.height/2) , duration: Double(CGFloat.random()))
        // 2
//        let actionMove = SKAction.move(to:CGPoint(x: -enemy.size.width/2,
//                                                  y: enemy.position.y), duration:Double(CGFloat.random()))
//        let wait = SKAction.wait(forDuration: 0.5)
//        let logMessage = SKAction.run({
//            print("Reached bottom!")
//        })
//        let reverseMid = actionMidMove.reversed()
//        let reverseMove = actionMove.reversed()
        // 3
//        let halfSequence = SKAction.sequence([actionMidMove, logMessage, wait, actionMove])
//        let sequence = SKAction.sequence([halfSequence, halfSequence.reversed()])
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([actionMove, removeAction])
        
        // 4
        enemy.run(sequence)
    }
    
    func spawnCat(){
        // 1
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        cat.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                               y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        cat.setScale(0)
        addChild(cat)
        // 2
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        cat.zRotation = -π / 16.0
        let leftWiggle = SKAction.rotate(byAngle: π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        
        let scaleUp = SKAction.scale(by:1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeat(group, count: 10)
        
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, disappear, removeFromParent]
        cat.run(SKAction.sequence(actions))
    }
    
    func startZombieAnimation()
    {
        if zombie.action(forKey: "animation") == nil {
            zombie.run(SKAction.repeatForever(zombieAnimation), withKey: "animation")
        }
    }
    func stopZombieAnimation(){
        zombie.removeAction(forKey: "animation")
    }
    
    func zombieHitCat(cat: SKSpriteNode){
//        cat.removeFromParent()
//        run(SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false))
        if !invinsible {
            cat.name = "train"
            cat.removeAllActions()
            cat.setScale(1.0)
            cat.zRotation = 0
            cat.run(SKAction.colorize(with: SKColor.green, colorBlendFactor: 0.75, duration: 0.2))
            run(catCollisionSound)
        }
    }
    
    func zombieHitEnemy(enemy: SKSpriteNode){
        if !invinsible {
//            enemy.removeFromParent()
            invinsible = true
            run(enemyCollisionSound)
            becomeInvinsible(sprite: zombie)
        }
//        run(SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false))
    }
    
    func becomeInvinsible(sprite: SKSpriteNode){
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration, actionBlock: { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        })
        let completion = SKAction.run({self.invinsible = false})
//        sprite.run(blinkAction, completion: completion)
        sprite.run(SKAction.sequence([blinkAction, completion]))
    }
    
    func collisionDetect(){
        var hitCats : [SKSpriteNode] = []
        enumerateChildNodes(withName: "cat", using: { node, _ in
            let cat = node as? SKSpriteNode
            if cat != nil
            {
                if cat!.frame.intersects(self.zombie.frame.insetBy(dx: 50, dy: 50)){
                    hitCats.append(cat!)
                }
            }
        })
        for cat in hitCats{
            zombieHitCat(cat: cat)
        }
        
        var hitEnemies : [SKSpriteNode] = []
        enumerateChildNodes(withName: "enemy", using: { node, _ in
            let enemy = node as? SKSpriteNode
            if enemy != nil{
                //zombieRect:(99.0, 282.0, 314.0, 204.0)
                //enemyRect:(1726.04895019531, 237.656005859375, 232.0, 322.0)
                if enemy!.frame.insetBy(dx: 50, dy: 50).intersects(self.zombie.frame.insetBy(dx: 50, dy: 50)){
                    hitEnemies.append(enemy!)
                }
            }
        })
        for enemy in hitEnemies{
            zombieHitEnemy(enemy: enemy)
        }
    }
    
    func moveTrain(){
        var targetPosition = zombie.position
        
        enumerateChildNodes(withName: "train", using: {node, _ in
            if !node.hasActions() {
                let actionDuration = 0.3
                let offset = node.position
                let direction = (targetPosition - offset).normalized()
                let amountToMovePerSec = direction * self.trainMovePointsPerSec * CGFloat(actionDuration)
                let rotationAction = SKAction.rotate(toAngle: direction.angle, duration: actionDuration)
                let moveToAction = SKAction.moveBy(x: amountToMovePerSec.x, y: amountToMovePerSec.y, duration: actionDuration)
                node.run(SKAction.group([rotationAction, moveToAction]))
            }
            targetPosition = node.position
        })
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if(touch != nil)
        {
            lastTouchPosition = touch!.location(in: self)
            moveZombieToward(sprite: zombie, location: touch!.location(in: self))
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if(touch != nil)
        {
            lastTouchPosition = touch!.location(in: self) + CGPoint(x: 5, y: 5)
            moveZombieToward(sprite: zombie, location: touch!.location(in: self))
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if(touch != nil)
        {
            lastTouchPosition = touch!.location(in: self)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if(touch != nil)
        {
            lastTouchPosition = touch!.location(in: self)
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        dt = 1 / 60
        if(!calDistanceBetTouchAndSprite(sprite: zombie))
        {
            moveSprite(sprite: zombie, velocity: velocity)
        }
        else
        {
            stopZombieAnimation()
        }
        //rotateSprite(sprite: zombie, direction: velocity)
        rotateSprite(sprite: zombie, direction: velocity,rotateRadiansPerSec: zombieRotateRadiansPerSec)
        boundsCheckZombie(sprite: zombie)
        moveTrain()
//        collisionDetect()
    }
    
    override func didEvaluateActions(){
        collisionDetect()
    }
    
}

