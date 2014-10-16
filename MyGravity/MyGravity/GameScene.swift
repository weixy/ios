//
//  GameScene.swift
//  MyGravity
//
//  Created by weixy on 24/08/14.
//  Copyright (c) 2014 cyberimp. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    var items = [SKSpriteNode]()
    
    override func didMoveToView(view: SKView) {
        let titleLabel = SKLabelNode(fontNamed:"Chalkduster")
        titleLabel.text = "Gravity World"
        titleLabel.fontSize = 20
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-50)
        self.addChild(titleLabel)
        self.physicsWorld.gravity = CGVectorMake(0, -9.8)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = borderBody
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            println(location)
            //let ball = SKSpriteNode(color: getRandomColor(), size: CGSizeMake(30, 30))
            //ball.position = location
            
            let ball = SKShapeNode(circleOfRadius: 20)
            ball.strokeColor = UIColor.redColor()
            ball.fillColor = getRandomColor()
            ball.lineWidth = 5
            ball.position = location
            self.addChild(ball)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
            ball.physicsBody?.restitution = 0.5
        }
    }
    
    func getRandomColor() -> UIColor {
        var randomRed: CGFloat = CGFloat(drand48())
        var randomGreen: CGFloat = CGFloat(drand48())
        var randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
