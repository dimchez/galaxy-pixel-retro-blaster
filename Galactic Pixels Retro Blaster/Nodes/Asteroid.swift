//
//  Asteroid.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-21.
//

import SpriteKit

class Asteroid: SKSpriteNode, Updatable, Damageable {
    
    static let name = "asteroid"
    
    weak var delegate: AsteroidDelegate?
    
    private var health = 1.0
    
    private var angularVelocity: CGFloat
    
    private var velocity: CGVector
    
    init(_ texture: SKTexture, withDirection direction: AsteroidDirection) {
        let randomSpeed = CGFloat.random(in: 60...80)
        
        let angleOffset = CGFloat(direction.rawValue) * CGFloat.random(in: (CGFloat.pi / 2)...(5 * CGFloat.pi / 6)) // Random angle between 90 and 150 degrees, adjusted for direction
        
        self.velocity = CGVector(
            dx: cos(angleOffset) * randomSpeed,
            dy: sin(angleOffset) * randomSpeed
        )
        self.angularVelocity = CGFloat.random(in: -1...(-0.5)) // random rotation speed
        
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = Asteroid.name
        
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
    
    func takeDamage(in scene: SKScene) {
        health -= 0.105
        
        showHitEffect()
        
        if health <= 0 {
            delegate?.asteroidDidGetDestroyed(ofSize: .large)
            spawnSmallerAsteroids()
            explode(in: scene)
        }
    }
    
    private func setupPhysicsBody() {
        guard let texture = self.texture else { return }
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        physicsBody?.categoryBitMask = PhysicsCategories.asteroid
        physicsBody?.contactTestBitMask = PhysicsCategories.player | PhysicsCategories.enemy | PhysicsCategories.bullet
        physicsBody?.collisionBitMask = PhysicsCategories.asteroid
        
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 1.0
        physicsBody?.restitution = 0.8
        physicsBody?.friction = 0.3
        
    }
    
    private func spawnSmallerAsteroids() {
        guard let scene = self.scene else { return }
        
        let directions = [CGFloat.pi/6, -CGFloat.pi/6] // 30 and -30 degrees
        for direction in directions {
            let smallAsteroid = AsteroidFactory.shared.spawnAsteroid(from: direction, and: velocity, at: position)
            smallAsteroid.delegate = delegate
            scene.addChild(smallAsteroid)
        }
    }
}
