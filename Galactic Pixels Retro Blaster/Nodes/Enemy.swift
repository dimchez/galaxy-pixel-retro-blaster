//
//  Enemy.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-16.
//

import SpriteKit

class Enemy: SKSpriteNode, Updatable, Damageable {
    
    static let name = "enemy"
    
    weak var delegate: EnemyDelegate?
    
    var hasCollided = false
    
    var movementSpeed: CGFloat = 180
    
    var health = 1.0
    
    init() {
        super.init(texture: nil, color: .clear, size: CGSize.zero)
        self.name = Enemy.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime: TimeInterval) {
        let distance = movementSpeed * CGFloat(deltaTime)
        position.x -= distance
        
        if position.x < -size.width {
            removeFromParent()
        }
    }
    
    func setupAnimation(with frames: [SKTexture]) {
        let animationAction = SKAction.animate(with: frames, timePerFrame: 0.1)
        run(SKAction.repeatForever(animationAction))
    }
    
    func takeDamage(in scene: SKScene) {
        health -= 0.35
        
        showHitEffect()
        
        if health <= 0 {
            delegate?.enemyDidGetDestroyed()
            explode(in: scene)
        }
    }
    
    func setupPhysicsBody() {
        guard let texture = self.texture else { return }
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = PhysicsCategories.enemy
        physicsBody?.contactTestBitMask = PhysicsCategories.player | PhysicsCategories.bullet | PhysicsCategories.asteroid
        physicsBody?.collisionBitMask = PhysicsCategories.none
        physicsBody?.affectedByGravity = false
    }
}
