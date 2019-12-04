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
        let scene3 = GameOverScene(size: view.bounds.size)
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
        motionManager.gyroUpdateInterval = 0
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data {
                if myData.rotationRate.y > 2 {
                    print("detect shake")
                    player.addShield()
                    self.motionManager.gyroUpdateInterval = 4
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self.motionManager.gyroUpdateInterval = 0
                    }
                    
                }
            }
        }
    }
    
  
}
