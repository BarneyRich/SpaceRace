//
//  GameScene.swift
//  SpaceRace
//
//  Created by Barnabas Bala on 13.06.2022.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starField:SKEmitterNode!
    var Player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["tv","hammer","ball"]
    var gametimer: Timer!
    var isGameOver = false
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .black
        starField = SKEmitterNode(fileNamed: "starfield")
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        starField.zPosition = -1
        addChild(starField)
        
        
        Player = SKSpriteNode(imageNamed: "player")
        Player.position = CGPoint(x: 50, y: 384)
        Player.physicsBody = SKPhysicsBody(texture: Player.texture!, size: Player.size)
        Player.physicsBody?.contactTestBitMask = 1
        addChild(Player)
        

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 820, y: 680)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        

        gametimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        
        
    }
    
   
    
    override func update(_ currentTime: TimeInterval) {
        
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
       
        if !isGameOver {
            score += 1
        }
    }
    
    @objc func createEnemy(){
        guard let Enemy = possibleEnemies.randomElement() else {return}
        
        let sprite = SKSpriteNode(imageNamed: Enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
            
        } else if location.x > 668 {
            location.x = 668
            
        }
        
        Player.position = location
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = Player.position
        addChild(explosion)
        
        Player.removeFromParent()
        
        isGameOver = true
    }
    
//    func didEnd(_ contact: SKPhysicsContact) {
//        <#code#>
//    }
}
