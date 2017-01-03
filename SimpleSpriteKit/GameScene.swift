//
//  GameScene.swift
//  SimpleSpriteKit
//
//  Created by Daesub Kim on 2016. 12. 6..
//  Copyright (c) 2016년 DaesubKim. All rights reserved.
//


    
    import CoreMotion // motion
    import SpriteKit
    
    class GameScene: SKScene {
        var motionManager = CMMotionManager() // motion
        var dustSprite = SKSpriteNode(imageNamed:"default_img") // sprite moved by motion
        var destX: CGFloat = 0.0
        var destY: CGFloat = 0.0
        var positionLabel = SKLabelNode(fontNamed: "Courier")
        
        func setupHud() {
            positionLabel.name = "dustSprite Position"
            positionLabel.fontSize = 35
            positionLabel.text = String(format: "x: %.1f%% y: %.1f%%",destX, destY)
            positionLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame) - 50)
            self.addChild(positionLabel)
        }
        
        override func didMoveToView(view: SKView) {
            motionManager.startAccelerometerUpdates() // motion
            
            dustSprite.xScale = 1.5
            dustSprite.yScale = 1.5
            dustSprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            dustSprite.runAction(SKAction.repeatActionForever(action))
            self.addChild(dustSprite)
            
            if motionManager.accelerometerAvailable == true {
                motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {
                    data, error in
                    let currentX = self.dustSprite.position.x
                    if data!.acceleration.x < 0 {
                        self.destX = currentX + CGFloat(data!.acceleration.x * 100)
                    }
                    else if data!.acceleration.x > 0 {
                        self.destX = currentX + CGFloat(data!.acceleration.x * 100)
                    }
                    let currentY = self.dustSprite.position.y
                    if data!.acceleration.y < 0 {
                        self.destY = currentY + CGFloat(data!.acceleration.y * 100)
                    }
                    else if data!.acceleration.y > 0 {
                        self.destY = currentY + CGFloat(data!.acceleration.y * 100)
                    }
                })
            }
            
            /* Setup your scene here */
            let myLabel = SKLabelNode(fontNamed:"Chalkduster")
            myLabel.text = "Hello, Sprite!"
            myLabel.fontSize = 45
            myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            self.addChild(myLabel)
            
            setupHud() // hud
        }
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            /* Called when a touch begins */
            
            for touch in touches {
                let location = touch.locationInNode(self)
                
                let sprite = SKSpriteNode(imageNamed:"Spaceship")
                
                sprite.xScale = 0.5
                sprite.yScale = 0.5
                sprite.position = location
                
                let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
                
                sprite.runAction(SKAction.repeatActionForever(action))
                
                self.addChild(sprite)
            }
        }
        
        override func update(currentTime: CFTimeInterval) {
            /* Called before each frame is rendered */
            
            positionLabel.text = String(format: "x: %.1f%% y: %.1f%%",destX, destY)
            
            let maxX = CGRectGetMaxX(self.frame) - dustSprite.size.width
            let maxY = CGRectGetMaxY(self.frame) - dustSprite.size.height
            let minX = CGRectGetMinX(self.frame) + dustSprite.size.width
            let minY = CGRectGetMinY(self.frame) + dustSprite.size.height
            if destX > maxX {
                destX = maxX
            }
            else if destX < minX {
                destX = minX
            }
            if destY > maxY {
                destY = maxY
            }
            else if destY < minY {
                destY = minY
            }
            
            let action = SKAction.moveTo(CGPoint(x: destX, y: destY), duration: 1)
            self.dustSprite.runAction(action)
        }
    }

