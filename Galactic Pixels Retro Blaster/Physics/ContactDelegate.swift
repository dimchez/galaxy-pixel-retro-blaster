//
//  CollisionsHandler.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-19.
//

import SpriteKit

class ContactDelegate {
    
    unowned let scene: SKScene
    
    init(for scene: SKScene) {
        self.scene = scene
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategories.player | PhysicsCategories.enemy {
            let playerNode = getNode(with: Player.name, in: contact)
            let enemyNode = getNode(with: Enemy.name, in: contact)
            
            handleCollisionBetween(player: playerNode as? Player,
                                   and: enemyNode as? Enemy)
        } else if collision == PhysicsCategories.player | PhysicsCategories.asteroid {
            let playerNode = getNode(with: Player.name, in: contact)
            handleAsteroidCollisionWith(player: playerNode as? Player)
        } else if collision == PhysicsCategories.player | PhysicsCategories.asteroidSmall {
            let playerNode = getNode(with: Player.name, in: contact)
            let asteroidNode = getNode(with: AsteroidSmall.name, in: contact)
            
            handleCollisionBetween(player: playerNode as? Player, and: asteroidNode as? AsteroidSmall)
        } else if collision == PhysicsCategories.bullet | PhysicsCategories.enemy {
            let bulletNode = getNode(with: Bullet.name, in: contact)
            let enemyNode = getNode(with: Enemy.name, in: contact)
            
            handleCollisionBetween(bullet: bulletNode as? Bullet,
                                   and: enemyNode as? Enemy,
                                   at: contact.contactPoint)
        } else if collision == PhysicsCategories.bullet | PhysicsCategories.asteroid {
            let bulletNode = getNode(with: Bullet.name, in: contact)
            let asteroidNode = getNode(with: Asteroid.name, in: contact)
            
            handleCollisionBetween(bullet: bulletNode as? Bullet, and: asteroidNode as? Asteroid, at: contact.contactPoint)
        } else if collision == PhysicsCategories.asteroid | PhysicsCategories.enemy {
            let enemyNode = getNode(with: Enemy.name, in: contact)
            handleAsteroidCollisionWith(enemy: enemyNode as? Enemy)
        } else if collision == PhysicsCategories.asteroidSmall | PhysicsCategories.bullet {
            let bulletNode = getNode(with: Bullet.name, in: contact)
            let asteroidNode = getNode(with: AsteroidSmall.name, in: contact)
            
            handleCollisionBetween(bullet: bulletNode as? Bullet, and: asteroidNode as? AsteroidSmall, at: contact.contactPoint)
        } else if collision == PhysicsCategories.asteroidSmall | PhysicsCategories.enemy {
            let enemyNode = getNode(with: Enemy.name, in: contact)
            let asteroidNode = getNode(with: AsteroidSmall.name, in: contact)
            handleCollisionBetween(asteroid: asteroidNode as? AsteroidSmall, and: enemyNode as? Enemy)
        }
    }
    
    private func getNode(with name: String, in contact: SKPhysicsContact) -> SKNode? {
        contact.bodyA.node?.name == name ? contact.bodyA.node : contact.bodyB.node
    }
    
    private func handleCollisionBetween(player: Player?, and enemy: Enemy?) {
        guard let playerNode = player, let enemyNode = enemy else { return }
        
        guard enemyNode.hasCollided == false else { return }
        
        enemyNode.hasCollided = true
        enemyNode.explode(in: scene, withoutSoundFX: true)
        
        playerNode.explode(in: scene)
        playerNode.resetPosition(in: scene)
        playerNode.makeInvulnurable()
    }
    
    private func handleCollisionBetween(player: Player?, and asteroid: AsteroidSmall?) {
        guard let playerNode = player, let asteroidNode = asteroid else { return }
        
        asteroidNode.explode(in: scene, withoutSoundFX: true)
        
        playerNode.explode(in: scene)
        playerNode.resetPosition(in: scene)
        playerNode.makeInvulnurable()
    }
    
    private func handleCollisionBetween(bullet: Bullet?, and enemy: Enemy?, at position: CGPoint) {
        guard let bulletNode = bullet, let enemyNode = enemy else { return }
        
        guard enemyNode.hasCollided == false else { return }
        
        enemyNode.takeDamage(in: scene)
        
        BulletHitFactory.shared.playBulletHit(at: position, in: scene)
        
        bulletNode.removeFromParent()
    }
    
    private func handleCollisionBetween(asteroid: AsteroidSmall?, and enemy: Enemy?) {
        guard let asteroidNode = asteroid, let enemyNode = enemy else { return }
        
        guard enemyNode.hasCollided == false else { return }
        
        enemyNode.hasCollided = true
        enemyNode.explode(in: scene)
        
        asteroidNode.explode(in: scene)
    }
    
    private func handleCollisionBetween(bullet: Bullet?, and asteroid: Asteroid?, at position: CGPoint) {
        guard let bulletNode = bullet, let asteroidNode = asteroid else { return }
        
        asteroidNode.takeDamage(in: scene)
        
        BulletHitFactory.shared.playBulletHit(at: position, in: scene)
        
        bulletNode.removeFromParent()
    }
    
    private func handleCollisionBetween(bullet: Bullet?, and asteroid: AsteroidSmall?, at position: CGPoint) {
        guard let bulletNode = bullet, let asteroidNode = asteroid else { return }
        
        asteroidNode.takeDamage(in: scene)
        
        BulletHitFactory.shared.playBulletHit(at: position, in: scene)
        
        bulletNode.removeFromParent()
    }
    
    private func handleAsteroidCollisionWith(player: Player?) {
        guard let playerNode = player else { return }
        
        playerNode.explode(in: scene)
        playerNode.resetPosition(in: scene)
        playerNode.makeInvulnurable()
    }
    
    private func handleAsteroidCollisionWith(enemy: Enemy?) {
        guard let enemyNode = enemy else { return }
        
        guard enemyNode.hasCollided == false else { return }
        
        enemyNode.hasCollided = true
        enemyNode.explode(in: scene)
    }
}
