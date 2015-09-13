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

// Math Helpers
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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Background
    var background: SKNode!
    let background_speed = 100.0
    
    // Time Values
    var delta = NSTimeInterval(0)
    var last_update_time = NSTimeInterval(0)
    
    // MARK: - SKScene Initializacion
    override func didMoveToView(view: SKView) {
        initBackground()
    }

    // MARK: - Init Physics
    func initWorld() {
        
    }

    // MARK: - Init Bird
    func initBird() {
        
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
    // This function needs to return a SKSpriteNode otherwise a error will appear
    // to prevent the error while we add the new content just return an empty pipe for now
    let pipe:SKSpriteNode = SKSpriteNode()
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
        
    }

    // MARK: - Frames Per Second
    override func update(currentTime: CFTimeInterval) {
        delta = (last_update_time == 0.0) ? 0.0 : currentTime - last_update_time
        last_update_time = currentTime
        
        moveBackground()
    }
}
