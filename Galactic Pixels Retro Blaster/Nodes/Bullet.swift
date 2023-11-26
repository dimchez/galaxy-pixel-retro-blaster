//
//  Bullet.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-18.
//

import SpriteKit

class Bullet: SKSpriteNode, Updatable {
    
    static let name = "bullet"
    
    private let bulletSpeed: CGFloat = 1000.0
    
    init() {
        super.init(texture: nil, color: .clear, size: CGSize.zero)
        self.name = Bullet.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime: TimeInterval) {
        position.x += bulletSpeed * deltaTime
        
        guard let maxX = parent?.frame.maxX else { return }
                
        if position.x > maxX + size.width {
            removeFromParent()
        }
    }
    
    func fire(from position: CGPoint, direction: CGVector) {
        self.position = position
    }
    
    func setupAnimation(with frames: [SKTexture]) {
        let animationAction = SKAction.animate(with: frames, timePerFrame: 0.1)
        run(SKAction.repeatForever(animationAction))
    }
    
    func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = PhysicsCategories.bullet
        physicsBody?.contactTestBitMask = PhysicsCategories.enemy | PhysicsCategories.asteroid
        physicsBody?.collisionBitMask = PhysicsCategories.none
        physicsBody?.affectedByGravity = false
    }
}
