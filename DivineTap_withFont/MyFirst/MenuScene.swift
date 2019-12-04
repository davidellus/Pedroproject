//
//  MenuScene.swift
//  MyFirst
//
//  Created by Giovanni D'Ortenzio on 18/11/2019.
//  Copyright © 2019 Paolo Buia. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    var background = SKSpriteNode(imageNamed: "bgmenu2")
    var playButton = SKSpriteNode()
    var logo = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "start")
    let logoTex = SKTexture(imageNamed: "logo")
    var bestScore: SKLabelNode!
    var bestOverallScore = 00
    
    override func didMove(to view: SKView) {
        //Best Score Label
        bestScore = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        bestScore.fontSize = 46
        bestScore.position = CGPoint(x: frame.midX, y: frame.midY)
        bestScore.text = "Best score: \(bestOverallScore)"
        bestScore.zPosition = 3
        bestScore.fontColor = UIColor.systemOrange
        //self.addChild(bestScore)

        //Play Button
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY - 70)
        playButton.setScale(1)
        playButton.zPosition = 3
        self.addChild(playButton)

        //Logo
        logo = SKSpriteNode(texture: logoTex)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + 85)
                
                let moveDown = SKAction.moveBy(x: 0, y: -25, duration: 2)
                let moveUp = SKAction.moveBy(x: 0, y: 25, duration: 2)
                let moveLoop = SKAction.sequence([moveDown, moveUp])
                let moveForever = SKAction.repeatForever(moveLoop)
                logo.run(moveForever)
            
        logo.zPosition = 3
        self.addChild(logo)

        //Background
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = -1
        background.setScale(1.15)
        self.addChild(background)
        
        
        
        
        
        
        
        
        
        
        
        
        

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)

            if node == playButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}

