//
//  GameOverScene.swift
//  MyFirst
//
//  Created by Antonio Giugliano on 23/11/2019.
//  Copyright © 2019 Paolo Buia. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class GameOverScene: SKScene {
    var audioBackground = AVAudioPlayer()
    var gameOverScreen = SKSpriteNode()
    var gameOverScreenTex = SKTexture(imageNamed: "gameOver")
    var restartButton = SKSpriteNode()
    var restartTex = SKTexture(imageNamed: "restartButton")

    var halo = SKSpriteNode()
    var haloTex = SKTexture(imageNamed: "halo")
    
    var quitButton = SKSpriteNode()
    var quitTex = SKTexture(imageNamed: "exitButton")
    
    
    override func didMove(to view: SKView) {
       
    //Background
        backgroundColor = .black
        
        let sound = Bundle.main.path(forResource: "file", ofType: "mp3")

            do {

                audioBackground = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
                
                audioBackground.numberOfLoops = -1
                audioBackground.play()

                
            } catch {
                
            print(error)
            
        }
        
//  testo del Game Over
    
    GameOverScreen()
    RestartButton()
    QuitButton()
    Halo()
        

    }
        
       
    func GameOverScreen(){
        gameOverScreen = SKSpriteNode(texture: gameOverScreenTex)
        gameOverScreen.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        gameOverScreen.zPosition = 0
        gameOverScreen.setScale(0.5)
        addChild(gameOverScreen)
    }
    
    func RestartButton(){
        restartButton = SKSpriteNode(texture: restartTex)
        restartButton.position = CGPoint(x: frame.midX/2, y: frame.midY/2)
        restartButton.name = "BottoneRestart"
        restartButton.setScale(0.25)
        addChild(restartButton)
    }

    func QuitButton(){
        quitButton = SKSpriteNode(texture: quitTex)
        quitButton.position = CGPoint(x: frame.size.width*0.75, y: frame.midY/2)
        quitButton.name = "BottoneQuit"
        quitButton.setScale(0.75)
        addChild(quitButton)
    }
    
    func Halo(){
        halo = SKSpriteNode(texture: haloTex)
        halo.position = CGPoint(x: frame.midX, y: frame.midY)
        halo.zPosition=0
        halo.name = "halo"
        halo.setScale(0.3)
        addChild(halo)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
             for touch in touches {
                  let location = touch.location(in: self)
                  let touchedNode = atPoint(location)
                  if touchedNode.name == "BottoneQuit" {
    
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene3:SKScene = MenuScene(size: self.size)
                    scene?.removeAllActions()
                    self.view?.presentScene(scene3, transition: transition)
                        
                  }else if touchedNode.name == "BottoneRestart"{
    //                se premo il tasto play, parte la funzione play
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene3:SKScene = GameScene(size: self.size)
                    scene?.removeAllActions()
                    self.view?.presentScene(scene3, transition: transition)

                  }
        }
    
    
    
}


}
