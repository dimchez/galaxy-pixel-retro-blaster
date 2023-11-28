//
//  AsteroidSmall.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-22.
//

import SpriteKit

class AsteroidSmall: SKSpriteNode, Updatable, Damageable {
    
    static let name = "asteroid-small"
    
    weak var delegate: GameNodeDelegate?
    
    private var health = 1.0
    
    private var velocity: CGVector
    
    private var angularVelocity: CGFloat
    
    init(fromTexture texture: SKTexture, withVelocity velocity: CGVector, andPosition position: CGPoint) {
        self.velocity = velocity
        self.angularVelocity = CGFloat.random(in: -1...(-0.5)) // random rotation speed

        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = AsteroidSmall.name
        self.position = position
        
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime: TimeInterval) {
        let vectorDelta = velocity * CGFloat(deltaTime)
        position += vectorDelta
        
        zRotation += angularVelocity * CGFloat(deltaTime)
        
        guard let maxX = parent?.frame.maxX else { return }
        
        if position.x < -size.width || position.x > maxX + size.width {
            removeFromParent()
        }
    }
    
    func takeDamage(multipliedBy multiplier: CGFloat, in scene: SKScene) {
        health -= 0.26 * multiplier
        
        showHitEffect()
        
        if health <= 0 {
            delegate?.didGetDestroyed(nodeOfType: .asteroidSmall)
            explode(in: scene)
        }
    }
    
    private func setupPhysicsBody() {
        guard let texture = self.texture else { return }
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = PhysicsCategories.asteroidSmall
        physicsBody?.contactTestBitMask = PhysicsCategories.player | PhysicsCategories.enemy | PhysicsCategories.bullet | PhysicsCategories.asteroid
        physicsBody?.collisionBitMask = PhysicsCategories.none
        physicsBody?.affectedByGravity = false
    }
}
