//
//  GameScene.swift
//  MyFirst
//
//  Created by Paolo Buia on 08/11/2019.
//  Copyright © 2019 Paolo Buia. All rights reserved.
//

import SpriteKit
import AVFoundation
import UIKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let monster   : UInt32 = 0b1
    static let projectile: UInt32 = 0b10
    static let bear      : UInt32 = 0b11
    static let player    : UInt32 = 0b100
    static let shield    : UInt32 = 0b101
    static let boss      : UInt32 = 0b110
    static let spell     : UInt32 = 0b111
    static let enemy     : UInt32 = 0b1000
}

// DEFINIAMO LA CLASSE DELLO SCUDO
class Shield: SKSpriteNode{
    
    var resistence = 5
    
    init(){
        let texture = SKTexture(imageNamed: "shield")
// uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/3 ) // 1
        self.physicsBody?.isDynamic = true // 2
        self.physicsBody?.categoryBitMask = PhysicsCategory.shield // 3
        self.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        self.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        
        let fadeStart = SKAction.fadeAlpha(to: 0.3, duration: 1.0)
        let fadeEnd = SKAction.fadeAlpha(to: 0.5, duration: 1.0)
        let fadeSequence = SKAction.sequence([fadeStart,fadeEnd])
        let rotate = SKAction.rotate(byAngle: 0.5, duration: 3)
        let group = SKAction.group([fadeSequence,rotate])
        
        self.run(SKAction.repeatForever(group))
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

//Modificata
class Spell: SKSpriteNode{
    init(){
        let texture = SKTexture(imageNamed: "Bullet")
        // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 680, height: 40))
        
        
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
    var idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "ShieldImages", frameNamed: "shield-")
    
    init(){
        let firstFrameTexture = idleFrames[1]
        // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
        super.init(texture: firstFrameTexture, color: UIColor.clear, size: firstFrameTexture.size())
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/3 ) // 1
        self.physicsBody?.isDynamic = true // 2
        self.physicsBody?.categoryBitMask = PhysicsCategory.projectile // 3
        self.physicsBody?.contactTestBitMask = PhysicsCategory.boss
        self.physicsBody?.contactTestBitMask = PhysicsCategory.monster // 4
        self.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
    }
    
    //necessario per il corretto funzionamento
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

//DEFINIAMO LA CLASSE DEL BOSS
class Boss: Nodo{
    let idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "SorcererIdle", frameNamed: "sorcererIdle")
    
    init(){
        let firstFrameTexture = idleFrames[0]
        // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
        super.init(texture: firstFrameTexture, color: UIColor.clear, size: firstFrameTexture.size())
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height ) // 1
        self.physicsBody?.isDynamic = true // 2
        self.physicsBody?.categoryBitMask = PhysicsCategory.boss // 3
        self.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        self.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        life = 10
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
    
    //Modificata
    func shotSpell(){
        var count : Int = 5
        // 2 - Set up initial location of projectile
        let spell = Spell()
            spell.position = CGPoint(x : self.frame.width - 100 , y: self.frame.height/2 - 100)
        spell.zPosition = 11
        addChild(spell)
        
        for i in 0 ... 4{
        count += 5
        // 9 - Create the actions
            
            let actionMove = SKAction.move(to: CGPoint(x: -4900*(CGFloat(count/7)) * CGFloat(i), y: size.height*12 * -(CGFloat(i))),
        duration: TimeInterval(CGFloat(25.0)))
            
//            let posizione = CGPoint(x : player.position.x, y: player.position.y)
//            let actionMove = SKAction.move(to: posizione, duration: TimeInterval(CGFloat(2.0)))
        let actionMoveDone = SKAction.removeFromParent()
        let shotAction = SKAction.sequence([actionMove, actionMoveDone])
            spell.run(shotAction)
        }
        
    }
    
}


//DEFINIAMO LA CLASSE DELL'ORSO
class Orso: Nodo{
    var idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "BearImages", frameNamed: "bear")
    
     init(){
            let firstFrameTexture = idleFrames[0]
            // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
            super.init(texture: firstFrameTexture, color: UIColor.clear, size: firstFrameTexture.size())
            life = 10
            

            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/3 ) // 1
            self.physicsBody?.isDynamic = true // 2
            self.physicsBody?.categoryBitMask = PhysicsCategory.bear // 3
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

class Nodo: SKSpriteNode{
    
    var life = 10
}

//DEFINIAMO LA CLASSE DEL PLAYER
class Player: Nodo{
    var flagShield = 0
    var idleFrames: [SKTexture] = setAnimationFrames(folderNamed: "PlayerNewRun", frameNamed: "PlayerNewRun")
    var attackFrames: [SKTexture] = setAnimationFrames(folderNamed: "PlayerNewAttack", frameNamed: "PlayerNewAttack")
    
    
        init(){
            let firstFrameTexture = idleFrames[0]
    // uso questo initializer (costruttore) perchè è l'unico designato per SKSpriteNode
            super.init(texture: firstFrameTexture, color: UIColor.clear, size: firstFrameTexture.size())
            
            life = 100
            self.physicsBody = SKPhysicsBody(texture: idleFrames[0], size: CGSize(width : self.size.width, height : self.size.width)) // 1
                self.physicsBody?.isDynamic = true // 2
            self.physicsBody?.categoryBitMask = PhysicsCategory.player // 3
            self.physicsBody?.contactTestBitMask = PhysicsCategory.monster // 4
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
    
        func addShield(){
            let shield = Shield()
            shield.zPosition = 11
    // posiziona shield alla stessa posizione di self (di chi lo chiama)
            shield.position = .zero
            shield.setScale(2)
            addChild(shield)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Change `2.0` to the desired number of seconds.
                shield.removeShield()
                player.flagShield = 0
            }
            
        }
    func removeShield(){
        self.run(SKAction.fadeOut(withDuration: 0.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
            self.removeFromParent()
        }
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
//------------------------------------------------------------------------





//CLASSE DELLA GAME SCENE(dove tutta la magia comincia!!! :D)

class GameScene: SKScene {
    let worldNode = SKNode()
    var pausedLabel: SKSpriteNode!
    var pButton = SKSpriteNode(imageNamed: "pause")
    var bear = Orso()
    var bearWalkingFrames: [SKTexture] = []
    var boss = Boss()
    var flagBoss = 0
    var scoreLabel: SKLabelNode!
    var quitLabel = SKSpriteNode(imageNamed: "quit")
    var playB = SKSpriteNode(imageNamed: "play")
    let playerHealthBar = SKSpriteNode()
    let healthBarWidth: CGFloat = 60
    let healthBarHeight: CGFloat = 30
    let maxHealth = 100
//    var scoreIMG = SKSpriteNode(imageNamed: "score")
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
  override func didMove(to view: SKView) {
    // This sets up the physics world to have no gravity, and sets
    // the scene as the delegate to be notified when two physics bodies collide.
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    addPlayer()
    animate(spriteNode: player, arrayFrames: player.idleFrames)
    
    
//QUESTI SONO I VARI LAYER: posZ ci indica la posizione del layer (più il numero è negativo, più il layer starà dietro agli altri); se due layer hanno lo stesso posZ, allora quello che dichiariamo prima starà sotto quello dichiarato dopo
    createLayer(imageNamed: "background", posZ: -2, duration: 30)
    createLayer(imageNamed: "luna", posZ: -1, duration: 60)
    createLayer(imageNamed: "background2", posZ: 0, duration: 20)
    createLayer(imageNamed: "background3", posZ: 1, duration: 15)
    createLayer(imageNamed: "ground", posZ: 2, duration: 10)
    
    playerHealthBar.position = CGPoint(x: (frame.maxX - 680), y: frame.maxY - 60)
    addChild(playerHealthBar)
    updateHealthBar(playerHealthBar, withHealthPoints: maxHealth)
    
    createButton()
    createPAUSE()
    cqL()
//    cSI()
    createScore()
//    infinity_spawn_mob()
//    infinity_spawn_bear()
    ripetiControlloScore()
  }
   
    
    
// ------------------------------------------------------------------
//DEFINIZIONE DELLE VARIE FUNZIONI
 
    func controllaScore(){
        if score > 5 && flagBoss == 0{
            flagBoss = 1
            addBoss()
            animate(spriteNode: boss, arrayFrames: boss.idleFrames)
            
            infinity_spawn_spell()
        } else if score <= 5 {
            addBear()
            addMonster()
            
        }
            
        
    }
    
    func ripetiControlloScore(){
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(controllaScore),
            SKAction.wait(forDuration: 3.0)
            ])
        ))
    }
    
    func animate(spriteNode: SKSpriteNode, arrayFrames: [SKTexture] ) {
             spriteNode.run(SKAction.repeatForever(
                 SKAction.animate(with: arrayFrames,
                                  timePerFrame: 0.2,
                                  resize: false,
                                  restore: true)))
         }
     
    
//    FUNZIONE PER L'AGGIUNTA DELL'ORSO
    func addBear() {

            bear = Orso()
            
            // Determine where to spawn the monster along the Y axis
            
            
            bear.position = CGPoint(x: size.width + bear.size.width/2, y: size.height*0.3)
            bear.zPosition = 10
            bear.setScale(0.40)
            addChild(bear)
            
            animate(spriteNode: bear, arrayFrames: bear.idleFrames)
            
            // Create the actions
            let actionMove = SKAction.move(to: CGPoint(x: -bear.size.width/2, y: size.height*0.3),
                                           duration: TimeInterval(CGFloat(6.0)))
            let actionMoveDone = SKAction.removeFromParent()
            bear.run(SKAction.sequence([actionMove, actionMoveDone]))
  //        bear.addShield()
            
        }
    
//    FUNZIONE DELL'AGGIUNTA DEL BOSS
   func addBoss(){
    boss.zPosition = 11
    // posiziona shield alla stessa posizione di self (di chi lo chiama)
    boss.position = CGPoint(x: frame.size.width * 0.85, y: frame.size.height * 0.5)
        boss.setScale(0.5)
    addChild(boss)
    
        //modifica
//    let MoveTo = SKAction.move(to: CGPoint(x: frame.size.width * 0.85 , y: frame.size.height*0.5),
//                               duration: TimeInterval(0.5))
    let audioAction: SKAction = SKAction.playSoundFileNamed("Strega_Dario.mp3", waitForCompletion: false)
    let deleteBullet = SKAction.removeFromParent()
    let bulletSequence = SKAction.sequence([audioAction,deleteBullet])
    self.run(bulletSequence)
    boss.shotSpell()
    }
    
    
//    FUNZIONE PER L'AGGIUNTA DEL PLAYER
    func addPlayer() {
//      setta la posizione del player
        
        player.zPosition = 10
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.45)
        player.setScale(0.7)
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
    
    func infinity_spawn_spell(){
        
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(boss.shotSpell),
            SKAction.wait(forDuration: 2.5)
            ])
        ))
        
        
    }
    
//    FUNZIONI PER LO SPAWN INFINITO DI MOB
    
    func infinity_spawn_mob(){
//        ripetiamo all'infinito la sequenza composta da due parti: la prima parte della sequenza avvia la funzione add monster, mentre la seconda parte della sequenza da una pausa di 1 secondo: in questo modo otteiamo che viene generato un mob ogni secondo
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addMonster),
            SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    func infinity_spawn_bear(){
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addBear),
            SKAction.wait(forDuration: 3.0)
            ])
        ))
    }


//    FUNZIONI PER L'AGGIUNTA DELLA RANDOMITA'
  func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
  }

  func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
  }

//    FUNZIONE PER L'AGGIUNTA DEI MOB (NECESSITA DELLE DUE FUNZIONI RANDOM PRECEDENTI
  func addMonster() {
    
    // Create sprite
    let monster = SKSpriteNode(imageNamed: "monster")
    
    
    // Determine where to spawn the monster along the Y axis: scelgo come minimo 1/3 dell'altezza dello schermo e come massimo il massimo dello schermo meno la metà della dimensione effettiva del mob (in questo modo evitiamo di vedere fantasmini con la testa linciata lol)
    let actualY = random(min: frame.size.height*0.3, max: size.height - monster.size.height/3)
    
    // Position the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
    monster.zPosition = 10
    // Add the monster to the scene
    addChild(monster)
    
    monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
    monster.physicsBody?.isDynamic = true // 2
    monster.physicsBody?.categoryBitMask = PhysicsCategory.monster // 3
    monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
    monster.physicsBody?.collisionBitMask = PhysicsCategory.none // 5

    
    // Determine speed of the monster
    let actualDuration = random(min: CGFloat(1.0), max: CGFloat(2.0))
    
    // Create the actions: mettiamo y uguale a quella del player, così tutti i fantasmini andranno nella sua direzione. -900 indica una posizione negativa della x, fuori lo schermo
    let actionMove = SKAction.move(to: CGPoint(x: 0, y: frame.size.height*0.3),
                                   duration: TimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()
    monster.run(SKAction.sequence([actionMove, actionMoveDone]))
  }
    
      func updateHealthBar(_ node: SKSpriteNode, withHealthPoints hp: Int) {
          node.zPosition = 14
        let barSize = CGSize(width: healthBarWidth, height: healthBarHeight);
          
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
          
       
       func createPAUSE() {
           pausedLabel = SKSpriteNode(imageNamed: "play")
           pausedLabel.position = CGPoint(x: frame.midX, y: frame.midY)
           pausedLabel.zPosition = 100
           pausedLabel.name = "pulsantePlay"
           pausedLabel.isHidden=true
           addChild(pausedLabel)
       }
       
       func cqL() { //Creazione pulsante play
           quitLabel.position = CGPoint(x: frame.midX, y: frame.minY + 70)
           quitLabel.zPosition = 11
           quitLabel.name = "pulsanteQuit"
           quitLabel.setScale(0.5)
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
                   pause()
              }else if touchedNode.name == "pulsantePlay"{
//                se premo il tasto play, parte la funzione play
                play()
              }else if touchedNode.name == "pulsanteQuit"{
//                se premo il pulsante quit, creo una transizione di un secondo da una scena e l'altra, mi definisco la scena 2 che userò e chiudo tutte le azioni della scena attuale con removeAllAction (QUESTO ULTIMO PASSAGGIO è IMPORTANTE SICCOME SE NON SI CHIUDONO TUTTE LE AZIONI E SI FA PARTIRE UN'ALTRA SCENA, QUESTA ATTUALE E QUELLA PRECEDENTE SI SOVRAPPONGONO ED IL GIOCO CRASHA
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene2:SKScene = MenuScene(size: self.size)
                scene?.removeAllActions()
                self.view?.presentScene(scene2, transition: transition)
            }
         }
    }

    
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    shotProjectile(touches: touches)
    
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
        projectile.position = player.position
        projectile.zPosition = 11
        projectile.setScale(0.4)

        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if offset.x < 0 { return }
        
        // 5 - OK to add now - you've double checked position
            addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 12.0)
        let actionMoveDone = SKAction.removeFromParent()
        
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        animate(spriteNode: player, arrayFrames: player.attackFrames)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Change `2.0` to the desired number of seconds.
            
            self.animate(spriteNode: player, arrayFrames: player.idleFrames)
            
            //modificato
            let audioAction: SKAction = SKAction.playSoundFileNamed("Sparo_Personaggio.mp3", waitForCompletion: false)
            let deleteBullet = SKAction.removeFromParent()
            
            let bulletSequence = SKAction.sequence([audioAction,deleteBullet])
            self.run(bulletSequence)
        }
            }
  

   
//    VARIE FUNZIONI PER LE VARIE COLLISIONI
    
/*    COSA SUCCEDE QUANDO ABBIOAMO UNA COLLISIONE:
      abbiamo diverse funzioni, in base al tipo di collisione, o meglio,
      base al mob che colpiamo; per ognuna di esse, la metodica è la stessa: 1)   abbiamo un avviso nella command un avviso dell'effettiva            collisione (col print)
          2)   con removeFromParent, facciamo sparire il nodo che ha avuto la  collisione
          2.1) il punto 2) si verifica solo se la vita del mob è arrivata a    zero
          3)   aumentiamo lo score in base al tipo di mob che abbiamo ucciso */
    func projectileDidCollideWithBoss(projectile : SKSpriteNode, boss: Boss){
        print("Hit BOSSSS")
        boss.life -= 1
    }
  func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
//    let bulletAnimation  = shotProjectile(touches: Set<UITouch>)
    //modifica
    let audioAction: SKAction = SKAction.playSoundFileNamed("high_pitch_hitted.mp3", waitForCompletion: false)
    let deleteAudio = SKAction.removeFromParent()
    let bulletSequence = SKAction.sequence([audioAction,deleteAudio])
    self.run(bulletSequence)
    print("Hit")
    projectile.removeFromParent()
    monster.removeFromParent()
    score += 1
  }
    
    func projectileDidCollideWithBear(projectile: SKSpriteNode, bear: Orso) {
    
      print("Hit bear")
      projectile.removeFromParent()
        
      bear.life -= 1
        if bear.life == 0 {
            bear.removeFromParent()
            score += 10
        }
    }
    
    func projectileDidCollideWithShield(projectile: SKSpriteNode, shield: Shield) {
       
         print("Hit shield")
         projectile.removeFromParent()
        
        shield.resistence -= 1
        if shield.resistence == 0 {
            shield.removeShield()
        }
         
       }
    
    func spellDidCollideWithPlayer(spell: SKSpriteNode, player: Player) {
    
        print("Spell hit player")
        spell.removeFromParent()
        player.life -= 1
      
    }
    
    
    func monsterDidColliedWithPlayer(monster: SKSpriteNode, player: Player) {
      print("monster hit Player")
      monster.removeFromParent()
        if player.life == 0 {
            print("GameOver")
            player.removeFromParent()
            return
        }
        player.life -= 1
        print("\(player.life)")
        updateHealthBar(playerHealthBar, withHealthPoints: player.life)
     
    }
    
    
    func monsterDidColliedWithShield(monster: SKSpriteNode, shield: Shield){
        print("Hit Player")
        monster.removeFromParent()
        shield.removeShield()
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
    collisionBear(contact: contact)
    collisionShield(contact: contact)
    collisionPlayer(contact: contact)
    collisionPlayerWithSpell(contact: contact)
    collisionBoss(contact: contact)
    
  }
    
    func collisionBoss(contact: SKPhysicsContact) {
      // 1
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
    
    func collisionMob(contact: SKPhysicsContact) {
      // 1
      var firstBody: SKPhysicsBody?
      var secondBody: SKPhysicsBody?
        
      if contact.bodyA.categoryBitMask == PhysicsCategory.monster && contact.bodyB.categoryBitMask == PhysicsCategory.projectile {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
        
      } else if contact.bodyB.categoryBitMask == PhysicsCategory.monster && contact.bodyA.categoryBitMask == PhysicsCategory.projectile {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      // 2
      if firstBody != nil && secondBody != nil{
          if ((firstBody!.categoryBitMask & PhysicsCategory.monster != 0) &&
              (secondBody!.categoryBitMask & PhysicsCategory.projectile != 0)) {
              if let monster = firstBody!.node as? SKSpriteNode,
              let projectile = secondBody!.node as? SKSpriteNode {
                  projectileDidCollideWithMonster(projectile: projectile, monster: monster)
              }
              
          }
      }
      
    }
    
    
    
    func collisionPlayer(contact: SKPhysicsContact){
        // 1
             var firstBody: SKPhysicsBody?
             var secondBody: SKPhysicsBody?
               
             if contact.bodyA.categoryBitMask == PhysicsCategory.monster && contact.bodyB.categoryBitMask == PhysicsCategory.player {
               firstBody = contact.bodyA
               secondBody = contact.bodyB
               
             } else if contact.bodyB.categoryBitMask == PhysicsCategory.monster && contact.bodyA.categoryBitMask == PhysicsCategory.player {
               firstBody = contact.bodyB
               secondBody = contact.bodyA
                
             }
            
             // 2
             if firstBody != nil && secondBody != nil{
                 if ((firstBody!.categoryBitMask & PhysicsCategory.monster != 0) &&
                     (secondBody!.categoryBitMask & PhysicsCategory.player != 0)) {
                     if let monster = firstBody!.node as? SKSpriteNode,
                     let player = secondBody!.node as? SKSpriteNode {
                        monsterDidColliedWithPlayer(monster: monster, player: player as! Player)
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

    func collisionBear(contact: SKPhysicsContact) {
      // 1
      var firstBody: SKPhysicsBody?
      var secondBody: SKPhysicsBody?
      
      if contact.bodyA.categoryBitMask == PhysicsCategory.bear && contact.bodyB.categoryBitMask == PhysicsCategory.projectile {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else if contact.bodyB.categoryBitMask == PhysicsCategory.bear && contact.bodyA.categoryBitMask == PhysicsCategory.projectile {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      // 2
      if firstBody != nil && secondBody != nil{
          if ((firstBody!.categoryBitMask & PhysicsCategory.bear != 0) &&
              (secondBody!.categoryBitMask & PhysicsCategory.projectile != 0)) {
              if let bear = firstBody!.node as? SKSpriteNode,
              let projectile = secondBody!.node as? SKSpriteNode {
                projectileDidCollideWithBear(projectile: projectile, bear: bear as! Orso)
              }
          }
      }
    }
}

//----------------------------------------------------------------------------
