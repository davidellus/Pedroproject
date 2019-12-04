//
//  GameViewController.swift
//  MyFirst
//
//  Created by Paolo Buia on 08/11/2019.
//  Copyright © 2019 Paolo Buia. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class GameViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let scene2 = MenuScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene2)
        UIView.appearance().isExclusiveTouch = true

    }
  
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        motionManager.gyroUpdateInterval = 0.1
           motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
               if let myData = data {
                if myData.rotationRate.y > 2 && player.flagShield == 0{
                    print("detect shake")
                    player.addShield()
                    player.flagShield = 1
                    
                   }
               }
           }
    }
    
  
}
