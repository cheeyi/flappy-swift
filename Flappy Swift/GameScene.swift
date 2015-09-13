//
//  GameScene.swift
//  Flappy Swift
//
//  Created by Julio Montoya on 13/07/14.
//  Copyright (c) 2015 Julio Montoya. All rights reserved.
//
//  Copyright (c) 2015 AvionicsDev
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import SpriteKit

// MARK: Math Helpers
extension Float {
  static func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
    if (value > max) {
      return max
    } else if (value < min) {
      return min
    } else {
      return value
    }
  }
    
  static func range(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
  }
}

extension CGFloat {
    func deg_to_rad() -> CGFloat {
        return CGFloat(M_PI) * self / 180.0
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: Properties
    
    // Bird
    var bird: SKSpriteNode!
    
    //Background
    var background: SKNode!
    let background_speed = 100.0
    
    // Time Values
    var delta = NSTimeInterval(0)
    var last_update_time = NSTimeInterval(0)
    
    // Floor height
    let floor_distance: CGFloat = 72.0
    
    // Physics
    let FSBoundaryCategory: UInt32 = 1 << 0
    let FSPlayerCategory: UInt32 = 1 << 1
    let FSPipeCategory: UInt32 = 1 << 2
    let FSGapCategory: UInt32 = 1 << 3
    
    // MARK: - SKScene Initializacion
    override func didMoveToView(view: SKView) {
        initWorld()
        initBackground()
        initBird()
    }

    // MARK: - Init Physics
    func initWorld() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0) // -5G of gravity
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0.0, y: floor_distance, width: size.width, height: size.height - floor_distance))
        physicsBody?.categoryBitMask = FSBoundaryCategory
        physicsBody?.collisionBitMask = FSPlayerCategory
    }

    // MARK: - Init Bird
    func initBird() {
        bird = SKSpriteNode(imageNamed: "bird1")
        bird.position = CGPoint(x: 100.0, y: CGRectGetMidY(frame))
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width/2.5)
        bird.physicsBody?.categoryBitMask = FSPlayerCategory
        bird.physicsBody?.contactTestBitMask = FSPipeCategory | FSGapCategory | FSBoundaryCategory
        bird.physicsBody?.collisionBitMask = FSPipeCategory | FSBoundaryCategory
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.restitution = 0.0 // not bouncy
        bird.zPosition = 50
        
        addChild(bird)
        
        // Add two different textures that animate the bird
        let textures = [SKTexture(imageNamed: "bird1"), SKTexture(imageNamed: "bird2")]
        
        bird.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.1)))
    }

    // MARK: - Background Functions
    func initBackground() {
        background = SKNode()
        addChild(background)
        
        for i in 0...2 {
            let tile = SKSpriteNode(imageNamed: "bg")
            tile.anchorPoint = CGPointZero
            tile.position = CGPoint(x: CGFloat(i)*640.0, y: 0.0)
            tile.name = "bg"
            tile.zPosition = 10
            background.addChild(tile)
        }
    }

    func moveBackground() {
        let posX = -background_speed * delta
        background.position = CGPoint(x: background.position.x + CGFloat(posX), y: 0.0)
        
        background.enumerateChildNodesWithName("bg") {
            (node, stop) in
            let background_screen_position = self.background.convertPoint(node.position, toNode: self)
            
            if background_screen_position.x <= -node.frame.size.width {
                node.position = CGPoint(x: node.position.x + (node.frame.size.width * 2), y: node.position.y)
            }
        }
    }

    // MARK: - Pipes Functions
    func initPipes() {

    }

    func getPipeWithSize(size: CGSize, side: Bool) -> SKSpriteNode {
        let textureSize = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        let backgroundCGImage = UIImage(named: "pipe")!.CGImage
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawTiledImage(context, textureSize, backgroundCGImage)
        let tiledBackground = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let backgroundTexture = SKTexture(CGImage: tiledBackground.CGImage)
        let pipe = SKSpriteNode(texture: backgroundTexture)
        pipe.zPosition = 1
        
        let cap = SKSpriteNode(imageNamed: "bottom")
        cap.position = CGPoint(x: 0.0, y: side ? -pipe.size.height/2 + cap.size.height/2 : pipe.size.height/2 - cap.size.height/2)
        cap.zPosition = 5
        pipe.addChild(cap)
        
        if side == true {
            let angle: CGFloat = 180.0
            cap.zRotation = angle.deg_to_rad()
        }
        
        return pipe
    }

    // MARK: - Game Over helpers
    func gameOver() {
        
    }

    func restartGame() {
        
    }

    // MARK: - SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        
    }

    // MARK: - Touch Events
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Apply an impulse to the DY (vertical) value of the physics body of the bird
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 25))
    }

    // MARK: - Frames Per Second
    override func update(currentTime: CFTimeInterval) {
        delta = (last_update_time == 0.0) ? 0.0 : currentTime - last_update_time
        last_update_time = currentTime
        
        moveBackground()
        
        let velocity_x = bird.physicsBody?.velocity.dx
        let velocity_y = bird.physicsBody?.velocity.dy
        
        if velocity_y > 280 { // Max velocity is 280
            bird.physicsBody?.velocity = CGVector(dx: velocity_x!, dy: 280)
        }
        
        // Rotate bird based on its vertical velocity vector
        bird.zRotation = Float.clamp(-1, max: 0.0, value: velocity_y! * (velocity_y < 0 ? 0.003 : 0.001))
    }
}
