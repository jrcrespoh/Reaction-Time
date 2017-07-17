//
//  GameScene.swift
//  Reaction Time
//
//  Created by Jesus Crespo on 7/14/17.
//  Copyright © 2017 JCHTML. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var box = SKSpriteNode()
    
    var time = Date()
    
    var movingAnimation = SKAction()
    
    var tapCount = 0
    
    var reactionTime : Double = 0
    
    enum GameStatus {
        
        case ongoing, over, menu
        
    }
    
    var gameStatus = GameStatus.menu
    
    override func didMove(to view: SKView) {
        
        changeScene(to: GameStatus.menu)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch gameStatus {
            
            case .menu:
                if atPoint(touches.first!.location(in: self)) == self.childNode(withName: "start") {
                    changeScene(to: GameStatus.ongoing)
                }
            
            case .ongoing:
                handleTouch(touches: touches, event: event)
            
            case .over:
                if atPoint(touches.first!.location(in: self)) == self.childNode(withName: "restart") {
                    changeScene(to: GameStatus.ongoing)
                } else if atPoint(touches.first!.location(in: self)) == self.childNode(withName: "menu") {
                    changeScene(to: GameStatus.menu)
                }
            
        }
        
    }
    
    func changeScene(to status: GameStatus) {
        
        switch status {
            
            case .menu:
            
                for child in self.children {
                    child.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]))
                }
            
                let title = SKLabelNode(text: "Reaction Time")
                title.fontColor = UIColor.white
                title.fontSize = self.frame.width/10
                title.fontName = "Helvetica"
                title.position = CGPoint(x: 0, y: 0)
                self.addChild(title)
            
                let description = SKLabelNode(text: "Start")
                description.name = "start"
                description.fontColor = UIColor.lightGray
                description.fontSize = self.frame.width/15
                description.fontName = "Helvetica"
                description.position = CGPoint(x: 0, y: -self.frame.height/4)
                self.addChild(description)
                
                gameStatus = .menu
        
            case .ongoing:
            
                for child in self.children {
                    child.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]))
                }
                
                box = SKSpriteNode()
                box.color = UIColor.white
                box.size = CGSize(width: self.frame.height * 0.1, height: self.frame.height * 0.1)
                box.position = CGPoint(x: 0, y: self.frame.height/2-box.size.height/2)
                self.addChild(box)
                
                movingAnimation = SKAction.moveBy(x: 0, y: -box.size.height, duration: 0)
            
                gameStatus = .ongoing
            
            case .over:
                
                for child in self.children {
                    child.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]))
                }
                
                let title = SKLabelNode(text: "Results")
                title.fontColor = UIColor.white
                title.fontSize = self.frame.width/10
                title.fontName = "Helvetica"
                title.position = CGPoint(x: 0, y: self.frame.height/2 - title.fontSize)
                self.addChild(title)
                
                let reaction = SKLabelNode()
                reaction.fontColor = UIColor.lightGray
                reaction.fontSize = self.frame.width/15
                reaction.fontName = "Helvetica"
                reaction.position = CGPoint(x: 0, y: 0)
                reaction.text = "\(UInt32(reactionTime.rounded())) ms"
                self.addChild(reaction)
                
                let menu = SKLabelNode()
                menu.name = "menu"
                menu.fontColor = UIColor.white
                menu.fontSize = self.frame.width/15
                menu.fontName = "Helvetica"
                menu.position = CGPoint(x: 0, y: -self.frame.height/2+menu.fontSize)
                menu.text = "Back to Menu"
                self.addChild(menu)
                
                let restart = SKLabelNode()
                restart.name = "restart"
                restart.fontColor = UIColor.white
                restart.fontSize = self.frame.width/15
                restart.fontName = "Helvetica"
                restart.position = CGPoint(x: 0, y: -restart.fontSize * 2)
                restart.text = "Restart"
                self.addChild(restart)
                
                gameStatus = .over
            
        }
        
    }
    
    func handleTouch(touches: Set<UITouch>, event: UIEvent?) {
        
        if gameStatus == .ongoing {
            
            if tapCount == 8 {
                
                reactionTime = Date().timeIntervalSince(time) * 1000
                box.run(movingAnimation)
                tapCount = 0
                changeScene(to: GameStatus.over)
                
            } else if tapCount == 0 {
              
                time = Date()
                box.run(movingAnimation)
                tapCount += 1
                
            } else {
             
                box.run(movingAnimation)
                tapCount += 1
                
            }
            
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
