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

var background = SKSpriteNode(imageNamed: "background")

var nuvola1 = SKSpriteNode()
let nuvolaTex1 = SKTexture(imageNamed: "nuvola1")

var nuvola2 = SKSpriteNode()
let nuvolaTex2 = SKTexture(imageNamed: "nuvola2")

var playButton = SKSpriteNode()
let playButtonTex = SKTexture(imageNamed: "start")

var logo = SKSpriteNode()
let logoTex = SKTexture(imageNamed: "logo")

override func didMove(to view: SKView) {
    
    
    
    //Background
    background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    background.zPosition = -1
    background.setScale(1.15)
    self.addChild(background)
    
    //Logo
    logo = SKSpriteNode(texture: logoTex)
    
    logo.position = CGPoint(x: frame.midX, y: frame.maxY + 200)
    let lastPosition = SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY + 85), duration: 2)
    logo.run(lastPosition)
    
    let moveDown = SKAction.moveBy(x: 0, y: -25, duration: 2)
    let moveUp = SKAction.moveBy(x: 0, y: 25, duration: 2)
    let moveLoop = SKAction.sequence([moveDown, moveUp])
    let moveForever = SKAction.repeatForever(moveLoop)
        
    logo.zPosition = 3
    self.addChild(logo)
    
    //Play Button
    playButton = SKSpriteNode(texture: playButtonTex)
    
    playButton.position = CGPoint(x: frame.midX, y: frame.minY - 200)
    let playLastPos = SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY - 80 ), duration: 2)
    playButton.run(playLastPos)
    playButton.run(moveForever)

    
    playButton.setScale(1)
    playButton.zPosition = 3
    self.addChild(playButton)
    
    
    //nuvole
    nuvola1 = SKSpriteNode(texture: nuvolaTex1)
    nuvola2 = SKSpriteNode(texture: nuvolaTex2)
         
    nuvola1.zPosition = 0
    nuvola2.zPosition = 0
         
    nuvola1.position = CGPoint(x: frame.minX + 100, y: frame.maxY * 0.8)
    nuvola2.position = CGPoint(x: frame.maxX + 100, y: frame.maxY * 0.5)

    let nuv1LastPos = SKAction.moveBy(x: 150, y: 0, duration: 2)
    let nuv2LastPos = SKAction.moveBy(x: -300, y: 0, duration: 2)

    nuvola1.run(nuv1LastPos)
    nuvola2.run(nuv2LastPos)
         
    nuvola2.setScale(0.5)
    self.addChild(nuvola1)
    self.addChild(nuvola2)

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

