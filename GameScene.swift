//
//  GameScene.swift
//  MyFirst
//
//  Created by Paolo Buia on 08/11/2019.
//  Copyright © 2019 Paolo Buia. All rights reserved.
//

import SpriteKit
import AVFoundation

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let bat   : UInt32 = 0b1
    static let projectile: UInt32 = 0b10
    static let skeleton      : UInt32 = 0b11
    static let player    : UInt32 = 0b100
    static let shield    : UInt32 = 0b101
    static let boss      : UInt32 = 0b110
    static let spell     : UInt32 = 0b111
    static let enemy     : UInt32 = 0b1000
    static let shieldPlayer     : UInt32 = 0b1001
}

// DEFINIAMO LA CLASSE DELLO SCUDO
class Shield: SKSpriteNode{
    
    var resistence = 50
    var idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "shieldboss", frameNamed: "shieldBoss")
    
    init(){
        let firstFrameTexture = idleFrames[0]
        // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
        super.init(texture: firstFrameTexture, color: UIColor.clear, size: firstFrameTexture.size())
// fisica proiettile shield da fixare
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/2 ) // 1
        self.physicsBody?.isDynamic = true // 2
        self.physicsBody?.categoryBitMask = PhysicsCategory.shield // 3
        self.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        self.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        
//        let fadeStart = SKAction.fadeAlpha(to: 0.3, duration: 0.5)
//        let fadeEnd = SKAction.fadeAlpha(to: 0.5, duration: 1.0)
//        let fadeSequence = SKAction.sequence([fadeStart,fadeEnd])
//        let rotate = SKAction.rotate(byAngle: 0.5, duration: 3)
//        let group = SKAction.group([fadeSequence,rotate])
//        per rendere shield trasparente
        self.alpha = 0.5
        
//        self.run(SKAction.repeatForever(fadeSequence))
    }
//necessario per il corretto funzionamento
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func removeShield(){
        self.run(SKAction.fadeOut(withDuration: 0.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
            self.removeFromParent()
        }
    }
}

class Spell: SKSpriteNode{
    var idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "playerBullet", frameNamed: "playerBullet-")
    
    init(){
        let firstFrameTexture = idleFrames[0]
        // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
        super.init(texture: firstFrameTexture, color: UIColor.clear, size: firstFrameTexture.size())
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/3 ) // 1
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.spell // 3
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player // 4
        self.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
    }
    
    //necessario per il corretto funzionamento
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Projectile: Nodo{
    var idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "playerBullet", frameNamed: "playerBullet-")
    
    init(){
        let firstFrameTexture = idleFrames[0]
        // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
        super.init(texture: firstFrameTexture, color: UIColor.clear, size: firstFrameTexture.size())
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/3 ) // 1
        self.physicsBody?.isDynamic = true // 2
        self.physicsBody?.categoryBitMask = PhysicsCategory.projectile // 3
        self.physicsBody?.contactTestBitMask = PhysicsCategory.bat// 4
        self.physicsBody?.contactTestBitMask = PhysicsCategory.boss
        self.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
    }
    
    //necessario per il corretto funzionamento
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
//LA CLASSE NODO
class Nodo: SKSpriteNode{
    
    var life = 10
}

//DEFINIAMO LA CLASSE DEL BOSS
class Boss: Nodo{
    let idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "SorcererIdle", frameNamed: "sorcererIdle")
    var attackFrames: [SKTexture] = setAnimationFrames(folderNamed: "SorcerAttack", frameNamed: "sorcererAtt-")
    
    init(){
        let firstFrameTexture = idleFrames[0]
        // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
        super.init(texture: firstFrameTexture, color: UIColor.clear, size: firstFrameTexture.size())
        life = 50
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/5) // 1
        self.physicsBody?.isDynamic = true // 2
        self.physicsBody?.categoryBitMask = PhysicsCategory.boss // 3
        self.physicsBody?.contactTestBitMask = PhysicsCategory.projectile// 4
        self.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
    }
//necessario per il corretto funzionamento
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addShield(){
        let shield = Shield()
        shield.zPosition = 11
// posiziona shield alla stessa posizione di self (di chi lo chiama)
        shield.position = .zero
        shield.setScale(3)
        addChild(shield)
         animate(spriteNode: shield, arrayFrames: shield.idleFrames)
    }
    
    //ripetizione infinita
    func animate(spriteNode: SKSpriteNode, arrayFrames: [SKTexture] ) {
             spriteNode.run(SKAction.repeatForever(
                 SKAction.animate(with: arrayFrames,
                                  timePerFrame: 0.1,
                                  resize: false,
                                  restore: true)))
         }
    
    //ripetizione singola
    func animateAttack(spriteNode: SKSpriteNode, arrayFrames: [SKTexture] ) {
        
        spriteNode.run(SKAction.animate(with: arrayFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true))
        

    }
        
    
    func shotSpell(){
            
            // 2 - Set up initial location of projectile
            let spell = Spell()
            spell.position = .zero
            spell.zPosition = 11
        spell.setScale(0.4)
//            addChild(spell)
            
            // 9 - Create the actions
    //        let actionMove = SKAction.move(to: CGPoint(x: -5000, y: size.height*0.1),
    //        duration: TimeInterval(CGFloat(2.0)))
        let audioAction: SKAction = SKAction.playSoundFileNamed("Colpo_Strega.mp3", waitForCompletion: false)
            let actionMove = SKAction.move(to: CGPoint(x: -5000, y: frame.size.height*(-2.3)),
            duration: TimeInterval(CGFloat(2.0)))
            let actionMoveDone = SKAction.removeFromParent()
            let shotAction = SKAction.sequence([audioAction,actionMove, actionMoveDone])
        SKAction.removeFromParent()
            
            //    anima l'attacco player, dopo tot sec aggiunge il nodo proiettile e lo anima
            animateAttack(spriteNode: self, arrayFrames: self.attackFrames)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                
                self.addChild(spell)
                self.animate(spriteNode: spell, arrayFrames: spell.idleFrames)
                
                spell.run(shotAction)
                
                
            }
        }
    

    
        func repeatScheme(){
            run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(self.shotSpell),
                SKAction.wait(forDuration: 0.3),
                SKAction.run(self.shotSpell),
                SKAction.wait(forDuration: 0.3),
                SKAction.run(self.shotSpell),
                SKAction.wait(forDuration: 0.3),
                SKAction.run(self.shotSpell),
                SKAction.wait(forDuration: 3.3)
                ])
            ))
        }
    
}

//LA CLASSE DEL PIPISTRELLO
class Bat: Nodo{
    
    var idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "BatFrames", frameNamed: "bat")
    
    
    init(){
            let firstFrameTexture = idleFrames[0]
            // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
            super.init(texture: firstFrameTexture, color: UIColor.clear, size: firstFrameTexture.size())
            life = 1
            

             self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height)// 1
             self.physicsBody?.isDynamic = true // 2
             self.physicsBody?.categoryBitMask = PhysicsCategory.bat // 3
             self.physicsBody?.contactTestBitMask = PhysicsCategory.projectile | PhysicsCategory.shieldPlayer
             self.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        }
    //necessario per il corretto funzionamento
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}





//DEFINIAMO LA CLASSE DELLO Skeleton
class Skeleton: Nodo{
    var idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "skeleWalk", frameNamed: "skeleWalk-")
    
     init(){
            let firstFrameTexture = idleFrames[0]
            // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
            super.init(texture: firstFrameTexture, color: UIColor.clear, size: firstFrameTexture.size())
            life = 3
            

            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/3 ) // 1
            self.physicsBody?.isDynamic = true // 2
            self.physicsBody?.categoryBitMask = PhysicsCategory.skeleton // 3
            self.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
            self.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        }
    //necessario per il corretto funzionamento
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func addShield(){
        let shield = Shield()
        shield.zPosition = 11
// posiziona shield alla stessa posizione di self (di chi lo chiama)
        shield.position = .zero
        shield.setScale(3)
        addChild(shield)
    }
    
}


//DEFINIAMO LA CLASSE DEL PLAYER
class Player: Nodo{
//    var flagShield = 0
    var idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "PlayerRun", frameNamed: "playerRun-")
    var attackFrames: [SKTexture] = setAnimationFrames(folderNamed: "PlayerAttack", frameNamed: "playerAttack-")
    
    
        init(){
            let firstFrameTexture = idleFrames[0]
    // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
            super.init(texture: firstFrameTexture, color: UIColor.clear, size: CGSize(width: 352, height: 176))
            
            life = 100
            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/8)
            self.physicsBody?.isDynamic = true // 2
            self.physicsBody?.categoryBitMask = PhysicsCategory.player // 3
            self.physicsBody?.contactTestBitMask = PhysicsCategory.bat // 4
            self.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
            
            
        }
    //necessario per il corretto funzionamento
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func jump(){
        // move up 20
        let jumpUpAction = SKAction.moveBy(x: 0, y:100, duration:0.2)
        // move down 20
        let jumpDownAction = SKAction.moveBy(x: 0, y:-100, duration:0.2)
        // sequence of move yup then down
        let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
        
        // make player run sequence
        self.run(jumpSequence)
    }
    
    func die(){
        player.removeFromParent()
        
        player.life = maxHealth
    }
    
        func addShield(){
            let shield = Shield()
            shield.zPosition = 11
    // posiziona shield alla stessa posizione di self (di chi lo chiama)
            shield.position = CGPoint(x: -80,y: 0)
            shield.setScale(1.3)
//    fa in modo che il proiettile non collida con lo scudo del player
            shield.physicsBody?.categoryBitMask = PhysicsCategory.shieldPlayer
            animate(spriteNode: shield, arrayFrames: shield.idleFrames)
            addChild(shield)
            
// shield rimosso dopo tot secondi
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                shield.removeShield()
//                player.flagShield = 0
            }
            
        }
//ripetizione infinita
func animate(spriteNode: SKSpriteNode, arrayFrames: [SKTexture] ) {
         spriteNode.run(SKAction.repeatForever(
             SKAction.animate(with: arrayFrames,
                              timePerFrame: 0.1,
                              resize: false,
                              restore: true)))
     }
    
    
    
}

//    FUNZIONI PER ANIMARE UN GENERICO PERSONAGGIO
func setAnimationFrames(folderNamed: String, frameNamed: String) -> [SKTexture] {
    let animatedAtlas = SKTextureAtlas(named: folderNamed)
    var arrayFrames: [SKTexture] = []

    let numImages = animatedAtlas.textureNames.count
    for i in 1...numImages {
    let textureName = "\(frameNamed)\(i)"
    arrayFrames.append(animatedAtlas.textureNamed(textureName))
    }
    return arrayFrames
}


//----------------------------------------------------------------
func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}


func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}
    var player = Player()
    let maxHealth = 100
//------------------------------------------------------------------------





//CLASSE DELLA GAME SCENE(dove tutta la magia comincia!!! :D)

class GameScene: SKScene {
//    creiamo queste variaabili andiamo a costruire delle variabili che possiamo utilizzare in tutte le funzioni ed hanno le caratteristiche delle classi da cui prendono nome
    var audioBackground = AVAudioPlayer()
    var soundBoss = AVAudioPlayer()
    let worldNode = SKNode()
    var pausedLabel: SKSpriteNode!
    var pButton = SKSpriteNode(imageNamed: "pause")
    var skeleton = Skeleton()
    var skeletonWalkingFrames: [SKTexture] = []
    var boss = Boss()
    var flagBoss = 0
    var bat = Bat()
    var scoreLabel: SKLabelNode!
    var goScreen = SKSpriteNode(imageNamed: "Game_Over")
    var quitLabel = SKSpriteNode(imageNamed: "exitButton")
    var playB = SKSpriteNode(imageNamed: "play")
    let playerHealthBar = SKSpriteNode()
    let healthBarWidth: CGFloat = 60
    let healthBarHeight: CGFloat = 30
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
  override func didMove(to view: SKView) {
    //barra della vita
    //Modifica pedro
    
    let labhealth : SKSpriteNode = SKSpriteNode.init(imageNamed: "healtBar")
    labhealth.position = CGPoint(x: (frame.maxX - 702), y: frame.maxY - 37)
    labhealth.setScale(1.8)
    labhealth.zPosition = 15
    addChild(labhealth)
    
    player.life = 100
    
    // This sets up the physics world to have no gravity, and sets
    // the scene as the delegate to be notified when two physics bodies collide.
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    let sound = Bundle.main.path(forResource: "Colonna", ofType: "mp3")

        do {

            audioBackground = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
            
            audioBackground.numberOfLoops = -1
            audioBackground.play()

            
        } catch {
            
        print(error)
        
    }
    
  
    
    
    
    
//QUESTI SONO I VARI LAYER: posZ ci indica la posizione del layer (più il numero è negativo, più il layer starà dietro agli altri); se due layer hanno lo stesso posZ, allora quello che dichiariamo prima starà sotto quello dichiarato dopo
    createLayer(imageNamed: "background", posZ: -2, duration: 30)
    createLayer(imageNamed: "luna", posZ: -1, duration: 60)
    createLayer(imageNamed: "background2", posZ: 0, duration: 20)
    createLayer(imageNamed: "background3", posZ: 1, duration: 15)
    createLayer(imageNamed: "ground", posZ: 2, duration: 10)
    
    playerHealthBar.position = CGPoint(x: (frame.maxX - 680), y: frame.maxY - 60)
    addChild(playerHealthBar)
    updateHealthBar(playerHealthBar, withHealthPoints: maxHealth)
    infinity_spawn_bat()
    infinity_spawn_skeleton()
    addPlayer()
    createButton()
    createPAUSE()
    cqL()
//    cSI()
    createScore()
    ripetiControlloScore()
  }
   
    
    
// ------------------------------------------------------------------
//DEFINIZIONE DELLE VARIE FUNZIONI
 
    func controllaScore(){
        
        if score >= 150 && flagBoss == 0{
            flagBoss = 1
            self.removeAction(forKey: "spawnSkeletons")
            addBoss()
        }
        
    }
    
   
    func controlloLife(){
           
                  gameOver()
                  audioBackground.pause()
           
           
       }
    
    
    func ripetiControlloScore(){
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(controllaScore),
            SKAction.wait(forDuration: 2.0)
            ])
        ))
    }
    
    
    
    
//ripetizione infinita
    func animate(spriteNode: SKSpriteNode, arrayFrames: [SKTexture] ) {
             spriteNode.run(SKAction.repeatForever(
                 SKAction.animate(with: arrayFrames,
                                  timePerFrame: 0.1,
                                  resize: false,
                                  restore: true)))
         }
//ripetizione singola
    func animateAttack(spriteNode: SKSpriteNode, arrayFrames: [SKTexture] ) {
        
        spriteNode.run(SKAction.animate(with: arrayFrames,
                             timePerFrame: 0.05,
                             resize: false,
                             restore: true))
        

    }
     
    
//    FUNZIONE PER L'AGGIUNTA DELL'Skeleton
    func addSkeleton() {

            skeleton = Skeleton()
//        skeletons spawnano di dimensioni diverse
            let dimension = random(min: 0.6, max: 0.8)
            // Determine where to spawn the bat along the Y axis
            skeleton.position = CGPoint(x: size.width + skeleton.size.width/2, y: size.height*0.32)
            skeleton.zPosition = 11
            skeleton.setScale(dimension)
            addChild(skeleton)
            
            animate(spriteNode: skeleton, arrayFrames: skeleton.idleFrames)
            
            // Create the actions
            let actionMove = SKAction.move(to: CGPoint(x: -skeleton.size.width/2, y: size.height*0.3),
                                           duration: TimeInterval(CGFloat(6.0)))
            let actionMoveDone = SKAction.removeFromParent()
            skeleton.run(SKAction.sequence([actionMove, actionMoveDone]))
  //        skeleton.addShield()
            
        }
    
//    FUNZIONE PER L'AGGIUNTA DEI PIPISTRELLI (NECESSITA DELLE DUE FUNZIONI RANDOM PRECEDENTI
    func addBat() {
      
      // Create sprite
          bat = Bat()
          bat.setScale(0.30)
      // Determine where to spawn the bat along the Y axis: scelgo come minimo 1/3 dell'altezza dello schermo e come massimo il massimo dello schermo meno la metà della dimensione effettiva del mob (in questo modo evitiamo di vedere fantasmini con la testa linciata lol)
      let actualY = random(min: frame.size.height*0.3, max: size.height - bat.size.height/3)
      
      // Position the bat slightly off-screen along the right edge,
      // and along a random position along the Y axis as calculated above
      bat.position = CGPoint(x: size.width + bat.size.width/2, y: actualY)
      bat.zPosition = 11
      // Add the Bat to the scene
      animate(spriteNode: bat, arrayFrames: bat.idleFrames)
      addChild(bat)
      

      
      // Determine speed of the bat
      let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
      
      // Create the actions: mettiamo y uguale a quella del player, così tutti i fantasmini andranno nella sua direzione. -900 indica una posizione negativa della x, fuori lo schermo
      let actionMove = SKAction.move(to: CGPoint(x: 0, y: frame.size.height*0.3),
                                     duration: TimeInterval(actualDuration))
      let actionMoveDone = SKAction.removeFromParent()
      bat.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    
    func addBoss(){
        let audioAction: SKAction = SKAction.playSoundFileNamed("Strega_Dario.mp3", waitForCompletion: false)
        
        audioBackground.stop()
        run(audioAction)
        SKAction.removeFromParent()
        let sound = Bundle.main.path(forResource: "newmusic", ofType: "mp3")

            do {

                soundBoss = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
                
                soundBoss.numberOfLoops = 0
                soundBoss.play()

                
            } catch {
                
            print(error)
            
        }
         boss.zPosition = 11
         // posiziona shield alla stessa posizione di self (di chi lo chiama)
         boss.position = CGPoint(x: size.width * 0.85, y: size.height * 0.46)
         boss.setScale(0.5)
         addChild(boss)
        animate(spriteNode: boss, arrayFrames: boss.idleFrames)
         boss.repeatScheme()
        boss.addShield()
     }
    
    
//    FUNZIONE PER L'AGGIUNTA DEL PLAYER
    func addPlayer() {
//      setta la posizione del player
        
        player.zPosition = 11
        player.position = CGPoint(x: size.width * 0.15, y: size.height * 0.27)
        player.setScale(0.7)
        
//       lo aggiunge come nodo e lo anima all'infinito
        animate(spriteNode: player, arrayFrames: player.idleFrames)
        addChild(player)
    }
    
    
    
 
//  FUNZIONE PER LA CREAZIONE DEI VARI LAYER
    func createLayer(imageNamed: String, posZ: Float, duration: Float) {
        let groundTexture = SKTexture(imageNamed: imageNamed)

        for i in 0 ... 3 {
            let ground = SKSpriteNode(texture: groundTexture)
                ground.zPosition = CGFloat(posZ)
            if(imageNamed == "luna"){
               
                ground.position = CGPoint(x: frame.size.width*0.45, y: frame.size.height*0.45)
                addChild(ground)
                let moveDown = SKAction.moveBy(x: 0, y: -300, duration: TimeInterval(duration))
                let moveUp = SKAction.moveBy(x: 0, y: 300, duration: TimeInterval(duration))
                let moveLoop = SKAction.sequence([moveDown, moveUp])
                let moveForever = SKAction.repeatForever(moveLoop)
                ground.run(moveForever)
            }else{
           
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: TimeInterval(duration))
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            ground.run(moveForever)
            }
        }
    }
    
    
//    FUNZIONI PER LO SPAWN INFINITO DI MOB
    
    func infinity_spawn_bat(){
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addBat),
            SKAction.wait(forDuration: 1.0),
            SKAction.run(addBat),
            SKAction.wait(forDuration: 1.0),
            SKAction.run(addBat),
            SKAction.wait(forDuration: 0.3),
            SKAction.run(addBat),
            SKAction.wait(forDuration: 0.4),
            SKAction.run(addBat),
            SKAction.wait(forDuration: 0.3),
            SKAction.run(addBat),
            SKAction.wait(forDuration: 0.5)
          ])
        ),
        withKey: "spawnBats")
    }
    
    func infinity_spawn_skeleton(){
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addSkeleton),
            SKAction.wait(forDuration: 1.0),
            SKAction.run(addSkeleton),
            SKAction.wait(forDuration: 1.0),
            SKAction.run(addSkeleton),
            SKAction.wait(forDuration: 0.7),
            SKAction.run(addSkeleton),
            SKAction.wait(forDuration: 0.4),
            SKAction.run(addSkeleton),
            SKAction.wait(forDuration: 0.3),
            SKAction.run(addSkeleton),
            SKAction.wait(forDuration: 0.5)
          ])
        ),
        withKey: "spawnSkeletons")
    }
    

//    FUNZIONI PER L'AGGIUNTA DELLA RANDOMITA'
  func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
  }

  func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
  }

    

    
      func updateHealthBar(_ node: SKSpriteNode, withHealthPoints hp: Int) {
          node.zPosition = 14
        node.position = CGPoint(x: frame.width*0.18, y: frame.height*0.9)
        // aumento lunghezza ed altezza
        let barSize = CGSize(width: healthBarWidth*3, height: healthBarHeight*0.75);
        
        
    
//        let healtBarBorder=SKTexture(imageNamed: "healtBar")
        
        
          
        let fillColor = UIColor(red: 113.0/255, green: 202.0/255, blue: 53.0/255, alpha:1)
        let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
        
        // create drawing context
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // draw the outline for the health bar
        borderColor.setStroke()
        let borderRect = CGRect(origin: CGPoint.zero, size: barSize)
       
        context.stroke(borderRect, width: 1)
        
        // draw the health bar with a colored rectangle
        fillColor.setFill()
          
          let barWidth = (barSize.width - 1) * CGFloat(hp) / CGFloat(maxHealth)
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        context.fill(barRect)
        
        // extract image
        guard let spriteImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        // set sprite texture and size
        
        node.texture = SKTexture(image: spriteImage)
        node.size = barSize
      }

      func createButton(){
                 pButton.position = CGPoint(x: frame.maxX - 60, y: frame.maxY - 50)
                 pButton.zPosition = 50
                 pButton.setScale(0.35)
                 pButton.name = "pulsantePausa"
                 addChild(pButton)
                 pButton.isUserInteractionEnabled = false
             }
    
      func gameOverScreen(){
              goScreen.position = CGPoint(x: frame.midX, y: frame.midY)
              goScreen.zPosition = 100
              goScreen.name = "screenGameOver"
              goScreen.isHidden = true
              addChild(goScreen)
          }
       
       func createPAUSE() {
           pausedLabel = SKSpriteNode(imageNamed: "play")
           pausedLabel.position = CGPoint(x: frame.midX, y: frame.midY)
           pausedLabel.zPosition = 100
           pausedLabel.name = "pulsantePlay"
           pausedLabel.isHidden=true
           addChild(pausedLabel)
       }
       
       func cqL() { //Creazione pulsante quit
           quitLabel.position = CGPoint(x: frame.midX, y: frame.minY + 70)
           quitLabel.zPosition = 11
           quitLabel.name = "pulsanteQuit"
           quitLabel.setScale(0.75)
           quitLabel.isHidden=true
           addChild(quitLabel)
       }
       
       
//       func cSI() { //Create Score Image
//              scoreIMG.position = CGPoint(x: pButton.position.x - 160, y: frame.maxY - 45)
//              scoreIMG.zPosition = 11
//              scoreIMG.setScale(0.5)
//              scoreIMG.name = "scoreLabel"
//              addChild(scoreIMG)
//          }
       
       
           
       //    FUNZIONI PER LA CREAZIONE DELLO SCORE
          func createScore() {
              scoreLabel = SKLabelNode(fontNamed: "Eight-Bit Madness")
              scoreLabel.position = CGPoint(x: pButton.position.x - 140, y: frame.maxY - 55)
            scoreLabel.fontSize = 44
              scoreLabel.zPosition = 50
              scoreLabel.text = "Score: 0"
              scoreLabel.fontColor = #colorLiteral(red: 0.9922955632, green: 0.8814116716, blue: 0.19393152, alpha: 1)
              scoreLabel.name = "scoreLabel1"
              addChild(scoreLabel)
          }
           
//       FUNZIONE DI PAUSA
       func pause(){
        
           childNode(withName: "pulsantePausa")?.isHidden=true
           childNode(withName: "pulsantePlay")?.isHidden = false
           childNode(withName: "pulsanteQuit")?.isHidden = false
           childNode(withName: "scoreLabel")?.isHidden = true
           childNode(withName: "scoreLabel1")?.isHidden = true
        
//      scrivendo solo isPaused mettiamo in pausa l'intero gioco (se impostato su true)
           isPaused = true
        
        
//        aggiungo questo elemento siccome c'è un problema nel caso in cui si mette prima l'app in pausa e poi in background: una volta riaperta il sistema ritorna automaticamente alla scena iniziale con la schermata di pausa attiva, ma con la scena che si muove sotto. così togliamo la velocità al gioco ed evitiamo questo problema (rimetteremo la velocità del gioco nella funzione start)
        physicsWorld.speed=0


       }

//    FUNZIONE GAME OVER
       
       func gameOver(){
          scene?.removeAllActions()
          if view != nil {
              let transition:SKTransition = SKTransition.fade(withDuration: 1)
              let scene:SKScene = GameOverScene(size: self.size)
              self.view?.presentScene(scene, transition: transition)
          }

           
       }
    
//    FUNZIONE DI PLAY
       func play(){
           childNode(withName: "pulsantePausa")?.isHidden = false
           childNode(withName: "pulsantePlay")?.isHidden = true
           childNode(withName: "pulsanteQuit")?.isHidden = true
           childNode(withName: "scoreLabel")?.isHidden = false
           childNode(withName: "scoreLabel1")?.isHidden = false

//          in questo caso isPause= false riavvia il gioco
           isPaused = false
        
           
//        per chiarimenti vedi la funzione pause
        

           physicsWorld.speed=1

       }
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         for touch in touches {
              let location = touch.location(in: self)
              let touchedNode = atPoint(location)
              if touchedNode.name == "pulsantePausa" {
//                se premo il pulsante pausa si avvia la funzione pausa
                audioBackground.pause()
                    pause()
              }else if touchedNode.name == "pulsantePlay"{
//                se premo il tasto play, parte la funzione play
                play()
                audioBackground.play()

              }else if touchedNode.name == "pulsanteQuit"{
//                se premo il pulsante quit, creo una transizione di un secondo da una scena e l'altra, mi definisco la scena 2 che userò e chiudo tutte le azioni della scena attuale con removeAllAction (QUESTO ULTIMO PASSAGGIO è IMPORTANTE SICCOME SE NON SI CHIUDONO TUTTE LE AZIONI E SI FA PARTIRE UN'ALTRA SCENA, QUESTA ATTUALE E QUELLA PRECEDENTE SI SOVRAPPONGONO ED IL GIOCO CRASHA
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene2:SKScene = MenuScene(size: self.size)
                scene?.removeAllActions()
                self.view?.presentScene(scene2, transition: transition)
                
              }else{
                shotProjectile(touches: touches)
                
            }
         }
    }

    
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    dopo un deley di tot secondi animate player idle
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { // Change `2.0` to the desired number of seconds.
//        self.animate(spriteNode: player, arrayFrames: player.idleFrames)
//    }
//    animate(spriteNode: player, arrayFrames: player.idleFrames)
    
  }
    
    
//    FUNZIONI PER IL LANCIO DEL PROIETTILE
    func shotProjectile(touches: Set<UITouch>){
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
          return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let projectile = Projectile()
        projectile.position = CGPoint(x: player.position.x, y: player.position.y)
        projectile.zPosition = 11
        projectile.setScale(0.1)

        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if offset.x < 0 { return }
        
        // 5 - OK to add now - you've double checked position
        
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
      
//    anima l'attacco player, dopo tot sec aggiunge il nodo proiettile e lo anima
        animateAttack(spriteNode: player, arrayFrames: player.attackFrames)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            
            self.addChild(projectile)
            self.animate(spriteNode: projectile, arrayFrames: projectile.idleFrames)
            let audioAction = SKAction.playSoundFileNamed("Sparo_Personaggio.mp3", waitForCompletion: false)
            //modifica pedro
            projectile.run(SKAction.sequence([audioAction,actionMove, actionMoveDone]))
            

            
            
        }
        
        
    
    }
    
//    VARIE FUNZIONI PER LE VARIE COLLISIONI
    
/*    COSA SUCCEDE QUANDO ABBIOAMO UNA COLLISIONE:
      abbiamo diverse funzioni, in base al tipo di collisione, o meglio,
      base al mob che colpiamo; per ognuna di esse, la metodica è la stessa: 1)   abbiamo un avviso nella command un avviso dell'effettiva            collisione (col print)
          2)   con removeFromParent, facciamo sparire il nodo che ha avuto la  collisione
          2.1) il punto 2) si verifica solo se la vita del mob è arrivata a    zero
          3)   aumentiamo lo score in base al tipo di mob che abbiamo ucciso */
    
  
    
    func projectileDidCollideWithBat(projectile: SKSpriteNode, bat: Bat) {
    
     //modifica pedro
     let audioAction: SKAction = SKAction.playSoundFileNamed("high_pitch_hitted-2.mp3", waitForCompletion: false)
     let deleteAudio = SKAction.removeFromParent()
     let bulletSequence = SKAction.sequence([audioAction,deleteAudio])
     self.run(bulletSequence)
     print("Hit")
     projectile.removeFromParent()
        bat.life -= 1
        if bat.life < 1 {
     bat.removeFromParent()
            score += 1}
    }
    
    func projectileDidCollideWithSkeleton(projectile: SKSpriteNode, skeleton: Skeleton) {
    
      print("Hit skeleton")
        let audioAction: SKAction = SKAction.playSoundFileNamed("Morte_Scheletro", waitForCompletion: false)
        
      projectile.removeFromParent()
      skeleton.life -= 1
        if skeleton.life < 1 {
            self.run(audioAction)
            SKAction.removeFromParent()
            skeleton.removeFromParent()
            score += 10
        }
    }
    
    func projectileDidCollideWithShield(projectile: SKSpriteNode, shield: Shield) {
       
         print("Hit shield")
         projectile.removeFromParent()
        shield.resistence -= 1
        if shield.resistence < 1 {
            shield.removeShield()
        }
         
       }
    
    func spellDidCollideWithPlayer(spell: Spell, player: Player) {
    
        print("Spell hit player")
        spell.removeFromParent()
        if player.life < 1 {
            player.die()
            controlloLife()
            return
        }
        player.life -= 10
        print("\(player.life)")
        updateHealthBar(playerHealthBar, withHealthPoints: player.life)
      
    }
    
    func spellDidCollideWithShield(spell: Spell, shield: Shield) {
    
        print("Spell hit shield")
        spell.removeFromParent()
        
      
    }
    
    func batDidCollideWithShield(bat: Bat, shield: Shield) {
    
        print("bat hit shieldplayer")
        bat.removeFromParent()
        
      
    }
    
    func skeletonDidCollideWithShield(skeleton: Skeleton, shield: Shield) {
    
        print("skeleton hit shieldplayer")
        skeleton.removeFromParent()
        
      
    }
    
    
    
    
//    func enemyDidColliedWithPlayer(enemy: SKSpriteNode, player: Player) {
//      print("bat hit Player")
//      enemy.removeFromParent()
//        if player.life < 1 {
//            player.die()
//            controlloLife()
//            return
//        }
//        player.life -= 1
//        print("\(player.life)")
//        updateHealthBar(playerHealthBar, withHealthPoints: player.life)
//
//    }
    func skeletonDidCollideWithPlayer(skeleton: Skeleton, player: Player) {
    
        print("skeleton hit player")
        skeleton.removeFromParent()
        if player.life < 1 {
            player.die()
            controlloLife()
            return
        }
        player.life -= 10
        print("\(player.life)")
        updateHealthBar(playerHealthBar, withHealthPoints: player.life)
      
    }
    
    func batDidCollideWithPlayer(bat: Bat, player: Player) {
    
        print("bat hit player")
        bat.removeFromParent()
        if player.life < 1 {
            player.die()
            controlloLife()
            return
        }
        player.life -= 10
        print("\(player.life)")
        updateHealthBar(playerHealthBar, withHealthPoints: player.life)
      
    }
    
    

    
    func projectileDidCollideWithBoss(projectile: SKSpriteNode, boss: Boss) {
    
      print("Hit Boss")
      projectile.removeFromParent()
        boss.life -= 1
        if boss.life < 1{
            boss.removeFromParent()
        }
    }
    

}


//----------------------------------------------------------------------

/*FAR PARTIRE LA GIUSTA COLLISIONE:
  seguono una serie di funzioni per il riconoscimento della giusta
  collisione; la metodica è sempre la stessa:
1)  creo due variabili che mi serviranno dopo
2)  funzionamento primo if: confrontiamo gli oggetti che collidono (bodyA e body B), in particolare la loro categorybitmask (un valore che si da alle varie categorie di nodi che riteniamo "simili" nel funzionamento) con le categorie dei nostri nodi, definite alla riga di codice 11. se esse coincidono allora inseriamo nelle nostre variabili i due oggetti (notare che facciamo coincidere con la variabile firstbody sempre il proiettile e con la seconda varibaile secondbody l'altro oggetto
3)  funzionamento secondo if: andiamo a passre il nodo dei nostri oggetti alle due variabili: infine facciamo partire una delle funzioni definite prima (FUNZIONI PER LE COLLISIONI RIGA 439
 
 
 */

extension GameScene: SKPhysicsContactDelegate {

  func didBegin(_ contact: SKPhysicsContact) {
    collisionMob(contact: contact)
    collisionskeleton(contact: contact)
    collisionShield(contact: contact)
//    collisionPlayer(contact: contact)
    collisionPlayerWithBat(contact: contact)
    collisionPlayerWithSkeleton(contact: contact)
    collisionPlayerWithSpell(contact: contact)
    collisionProjectileWithBoss(contact: contact)
    collisionShieldPlayerWithSpell(contact: contact)
    collisionShieldPlayerWithBat(contact: contact)
    collisionShieldPlayerWithSkeleton(contact: contact)
    
  }
    func collisionMob(contact: SKPhysicsContact) {
      // 1
      var firstBody: SKPhysicsBody?
      var secondBody: SKPhysicsBody?
      
      if contact.bodyA.categoryBitMask == PhysicsCategory.bat && contact.bodyB.categoryBitMask == PhysicsCategory.projectile {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else if contact.bodyB.categoryBitMask == PhysicsCategory.bat && contact.bodyA.categoryBitMask == PhysicsCategory.projectile {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      // 2
      if firstBody != nil && secondBody != nil{
          if ((firstBody!.categoryBitMask & PhysicsCategory.skeleton != 0) &&
              (secondBody!.categoryBitMask & PhysicsCategory.projectile != 0)) {
              if let bat = firstBody!.node as? SKSpriteNode,
              let projectile = secondBody!.node as? SKSpriteNode {
                projectileDidCollideWithBat(projectile: projectile, bat: bat as! Bat)
              }
          }
      }
    }
    

    
    func collisionProjectileWithBoss(contact: SKPhysicsContact){
        var firstBody: SKPhysicsBody?
         var secondBody: SKPhysicsBody?
           
         if contact.bodyA.categoryBitMask == PhysicsCategory.boss && contact.bodyB.categoryBitMask == PhysicsCategory.projectile {
           firstBody = contact.bodyA
           secondBody = contact.bodyB
           
         } else if contact.bodyB.categoryBitMask == PhysicsCategory.boss && contact.bodyA.categoryBitMask == PhysicsCategory.projectile {
           firstBody = contact.bodyB
           secondBody = contact.bodyA
         }
        
         // 2
         if firstBody != nil && secondBody != nil{
             if ((firstBody!.categoryBitMask & PhysicsCategory.boss != 0) &&
                 (secondBody!.categoryBitMask & PhysicsCategory.projectile != 0)) {
                 if let boss = firstBody!.node as? SKSpriteNode,
                 let projectile = secondBody!.node as? SKSpriteNode {
                    projectileDidCollideWithBoss(projectile: projectile, boss: boss as! Boss)
                 }
                 
             }
         }
        
    }
    
//    func collisionPlayer(contact: SKPhysicsContact){
//        // 1
//             var firstBody: SKPhysicsBody?
//             var secondBody: SKPhysicsBody?
//
//             if ((contact.bodyA.categoryBitMask == PhysicsCategory.bat || contact.bodyA.categoryBitMask == PhysicsCategory.skeleton) && contact.bodyB.categoryBitMask == PhysicsCategory.player) {
//               firstBody = contact.bodyA
//               secondBody = contact.bodyB
//
//
//             } else if ((contact.bodyB.categoryBitMask == PhysicsCategory.bat || contact.bodyB.categoryBitMask == PhysicsCategory.skeleton)
//                && contact.bodyA.categoryBitMask == PhysicsCategory.player) {
//               firstBody = contact.bodyB
//               secondBody = contact.bodyA
//
//
//             }
//
//             // 2
//             if firstBody != nil && secondBody != nil{
//                 if ((firstBody!.categoryBitMask & PhysicsCategory.bat != 0 || firstBody!.categoryBitMask & PhysicsCategory.skeleton != 0) &&
//                     (secondBody!.categoryBitMask & PhysicsCategory.player != 0)) {
//                     if let enemy = firstBody!.node as? SKSpriteNode,
//                     let player = secondBody!.node as? SKSpriteNode {
//                        batDidColliedWithPlayer(bat: bat, player: player as! Player)
//                     }
//
//                 }
//             }
//    }
    
    func collisionShieldPlayerWithSpell(contact: SKPhysicsContact){
        var firstBody: SKPhysicsBody?
         var secondBody: SKPhysicsBody?
         

         if contact.bodyA.categoryBitMask == PhysicsCategory.shieldPlayer && contact.bodyB.categoryBitMask == PhysicsCategory.spell {
           firstBody = contact.bodyA
           secondBody = contact.bodyB
         } else if contact.bodyB.categoryBitMask == PhysicsCategory.shieldPlayer && contact.bodyA.categoryBitMask == PhysicsCategory.spell {
           firstBody = contact.bodyB
           secondBody = contact.bodyA
         }
        
         // 2
         if firstBody != nil && secondBody != nil{
             if ((firstBody!.categoryBitMask & PhysicsCategory.shieldPlayer != 0) &&
                 (secondBody!.categoryBitMask & PhysicsCategory.spell != 0)) {
                 if let shield = firstBody!.node as? SKSpriteNode,
                 let spell = secondBody!.node as? SKSpriteNode {
                    spellDidCollideWithShield(spell: spell as! Spell,shield: shield as! Shield)
                 }
                 
             }
         }
    }
    
    func collisionShieldPlayerWithBat(contact: SKPhysicsContact){
        var firstBody: SKPhysicsBody?
         var secondBody: SKPhysicsBody?
         

         if contact.bodyA.categoryBitMask == PhysicsCategory.shieldPlayer && contact.bodyB.categoryBitMask == PhysicsCategory.bat {
           firstBody = contact.bodyA
           secondBody = contact.bodyB
         } else if contact.bodyB.categoryBitMask == PhysicsCategory.shieldPlayer && contact.bodyA.categoryBitMask == PhysicsCategory.bat {
           firstBody = contact.bodyB
           secondBody = contact.bodyA
         }
        
         // 2
         if firstBody != nil && secondBody != nil{
             if ((firstBody!.categoryBitMask & PhysicsCategory.shieldPlayer != 0) &&
                 (secondBody!.categoryBitMask & PhysicsCategory.bat != 0)) {
                 if let shield = firstBody!.node as? SKSpriteNode,
                 let bat = secondBody!.node as? SKSpriteNode {
                    batDidCollideWithShield(bat: bat as! Bat,shield: shield as! Shield)
                 }
                 
             }
         }
    }
    
    func collisionShieldPlayerWithSkeleton(contact: SKPhysicsContact){
        var firstBody: SKPhysicsBody?
         var secondBody: SKPhysicsBody?
         

         if contact.bodyA.categoryBitMask == PhysicsCategory.shieldPlayer && contact.bodyB.categoryBitMask == PhysicsCategory.skeleton {
           firstBody = contact.bodyA
           secondBody = contact.bodyB
         } else if contact.bodyB.categoryBitMask == PhysicsCategory.shieldPlayer && contact.bodyA.categoryBitMask == PhysicsCategory.skeleton {
           firstBody = contact.bodyB
           secondBody = contact.bodyA
         }
        
         // 2
         if firstBody != nil && secondBody != nil{
             if ((firstBody!.categoryBitMask & PhysicsCategory.shieldPlayer != 0) &&
                 (secondBody!.categoryBitMask & PhysicsCategory.skeleton != 0)) {
                 if let shield = firstBody!.node as? SKSpriteNode,
                 let skeleton = secondBody!.node as? SKSpriteNode {
                    skeletonDidCollideWithShield(skeleton: skeleton as! Skeleton, shield: shield as! Shield)
                 }
                 
             }
         }
    }
    
    func collisionShield(contact: SKPhysicsContact) {
      // 1

        
      var firstBody: SKPhysicsBody?
      var secondBody: SKPhysicsBody?
      

      if contact.bodyA.categoryBitMask == PhysicsCategory.shield && contact.bodyB.categoryBitMask == PhysicsCategory.projectile {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else if contact.bodyB.categoryBitMask == PhysicsCategory.shield && contact.bodyA.categoryBitMask == PhysicsCategory.projectile {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      // 2
      if firstBody != nil && secondBody != nil{
          if ((firstBody!.categoryBitMask & PhysicsCategory.shield != 0) &&
              (secondBody!.categoryBitMask & PhysicsCategory.projectile != 0)) {
              if let shield = firstBody!.node as? SKSpriteNode,
              let projectile = secondBody!.node as? SKSpriteNode {
                projectileDidCollideWithShield(projectile: projectile, shield: shield as! Shield)
              }
              
          }
      }
      
    }
    
    func collisionPlayerWithSkeleton(contact: SKPhysicsContact) {
      // 1
      var firstBody: SKPhysicsBody?
      var secondBody: SKPhysicsBody?
      
      if contact.bodyA.categoryBitMask == PhysicsCategory.player && contact.bodyB.categoryBitMask == PhysicsCategory.skeleton {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else if contact.bodyB.categoryBitMask == PhysicsCategory.player && contact.bodyA.categoryBitMask == PhysicsCategory.skeleton {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      // 2
      if firstBody != nil && secondBody != nil{
          if ((firstBody!.categoryBitMask & PhysicsCategory.player != 0) &&
              (secondBody!.categoryBitMask & PhysicsCategory.skeleton != 0)) {
              if let player = firstBody!.node as? SKSpriteNode,
              let skeleton = secondBody!.node as? SKSpriteNode {
                skeletonDidCollideWithPlayer(skeleton: skeleton as! Skeleton, player: player as! Player)
              }
          }
      }
    }
    
    func collisionPlayerWithBat(contact: SKPhysicsContact) {
      // 1
      var firstBody: SKPhysicsBody?
      var secondBody: SKPhysicsBody?
      
      if contact.bodyA.categoryBitMask == PhysicsCategory.player && contact.bodyB.categoryBitMask == PhysicsCategory.bat {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else if contact.bodyB.categoryBitMask == PhysicsCategory.player && contact.bodyA.categoryBitMask == PhysicsCategory.bat {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      // 2
      if firstBody != nil && secondBody != nil{
          if ((firstBody!.categoryBitMask & PhysicsCategory.player != 0) &&
              (secondBody!.categoryBitMask & PhysicsCategory.spell != 0)) {
              if let player = firstBody!.node as? SKSpriteNode,
              let bat = secondBody!.node as? SKSpriteNode {
                batDidCollideWithPlayer(bat: bat as! Bat, player: player as! Player)
              }
          }
      }
    }
    
    func collisionPlayerWithSpell(contact: SKPhysicsContact) {
      // 1
      var firstBody: SKPhysicsBody?
      var secondBody: SKPhysicsBody?
      
      if contact.bodyA.categoryBitMask == PhysicsCategory.player && contact.bodyB.categoryBitMask == PhysicsCategory.spell {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else if contact.bodyB.categoryBitMask == PhysicsCategory.player && contact.bodyA.categoryBitMask == PhysicsCategory.spell {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      // 2
      if firstBody != nil && secondBody != nil{
          if ((firstBody!.categoryBitMask & PhysicsCategory.player != 0) &&
              (secondBody!.categoryBitMask & PhysicsCategory.spell != 0)) {
              if let player = firstBody!.node as? SKSpriteNode,
              let spell = secondBody!.node as? SKSpriteNode {
                spellDidCollideWithPlayer(spell: spell as! Spell, player: player as! Player)
              }
          }
      }
    }

    func collisionskeleton(contact: SKPhysicsContact) {
      // 1
      var firstBody: SKPhysicsBody?
      var secondBody: SKPhysicsBody?
      
      if contact.bodyA.categoryBitMask == PhysicsCategory.skeleton && contact.bodyB.categoryBitMask == PhysicsCategory.projectile {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else if contact.bodyB.categoryBitMask == PhysicsCategory.skeleton && contact.bodyA.categoryBitMask == PhysicsCategory.projectile {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      // 2
      if firstBody != nil && secondBody != nil{
          if ((firstBody!.categoryBitMask & PhysicsCategory.skeleton != 0) &&
              (secondBody!.categoryBitMask & PhysicsCategory.projectile != 0)) {
              if let skeleton = firstBody!.node as? SKSpriteNode,
              let projectile = secondBody!.node as? SKSpriteNode {
                projectileDidCollideWithSkeleton(projectile: projectile, skeleton: skeleton as! Skeleton)
              }
          }
      }
    }
}

//----------------------------------------------------------------------------
