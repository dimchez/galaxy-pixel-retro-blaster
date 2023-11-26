//
//  Damageable.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-22.
//

import SpriteKit

protocol Damageable: AnyObject {
    func takeDamage(in scene: SKScene)
}

extension Damageable where Self: SKSpriteNode {
    func showHitEffect() {
        let originalColor = self.color
        let originalBlendFactor = self.colorBlendFactor
        
        self.color = .red
        self.colorBlendFactor = 0.5
        
        let wait = SKAction.wait(forDuration: 0.1)
        
        let returnToOriginalColor = SKAction.run {
            self.color = originalColor
            self.colorBlendFactor = originalBlendFactor
        }
        
        self.run(SKAction.sequence([wait, returnToOriginalColor]))
    }
}

extension Damageable where Self: SKSpriteNode {
    func explode(in scene: SKScene, withoutSoundFX: Bool? = false) {
        if withoutSoundFX != true {
            SoundEffects.shared.play(.explosion, in: scene)
        }
        
        ExplosionFactory.shared.playExplosion(at: position, in: scene)
        
        removeFromParent()
    }
}
