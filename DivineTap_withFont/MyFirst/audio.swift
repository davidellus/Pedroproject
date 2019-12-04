//
//  audio.swift
//  MyFirst
//
//  Created by Davide Fastoso on 21/11/2019.
//  Copyright © 2019 Paolo Buia. All rights reserved.
//

//import Foundation
//import SpriteKit
//
//class MonsterA : SKSpriteNode {
//
//    static var monsterAInScene = Set<Player>()
//    static let audioAction: SKAction = SKAction.playSoundFileNamed("MonsterA-audio", waitForCompletion: false) //Change to AVAudio for loop
//    static let audioNode = SKNode()
//
//    init (scene:SKScene) {
//          //Your init
//        if MonsterA.monsterAInScene.count == 0 {
//             //play audio
//             scene.addChild(MonsterA.audioNode)
//             MonsterA.playAudio()
//          }
//
//          MonsterA.monsterAInScene.insert(player)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    static func playAudio() {
//         //Play audio code
//        if MonsterA.audioNode.action(forKey: "audio") != nil {return}
//        MonsterA.audioNode.run(MonsterA.audioAction, withKey: "audio")
//
//    }
//    override func removeFromParent() {
//        MonsterA.monsterAInScene.remove(player)
//        if MonsterA.monsterAInScene.count == 0 {
//            //stop audio code
//            MonsterA.audioNode.removeAction(forKey: "audio")
//            MonsterA.audioNode.removeFromParent()
//        }
//        super.removeFromParent()
//    }
//}
