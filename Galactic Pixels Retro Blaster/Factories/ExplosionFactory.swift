//
//  ExplosionFactory.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-17.
//

import SpriteKit

class ExplosionFactory {
    static let shared = ExplosionFactory()
    
    static let atlas = SKTextureAtlas(named: "Explosion")
    
    static let textureFrames: [SKTexture] = {
        var frames: [SKTexture] = []
        let textureNames = ExplosionFactory.atlas.textureNames.sorted()
        
        for textureName in textureNames {
            let texture = ExplosionFactory.atlas.textureNamed(textureName)
            frames.append(texture)
        }
        
        return frames
    }()
    
    func playExplosion(at position: CGPoint, in scene: SKScene) {
        guard let firstFrame = ExplosionFactory.textureFrames.first else { return }
        
        let explosion = SKSpriteNode(texture: firstFrame)
        explosion.position = position
        explosion.name = "explosion"
        scene.addChild(explosion)
        
        let animate = SKAction.animate(with: ExplosionFactory.textureFrames, timePerFrame: 0.05)
        let removeNode = SKAction.removeFromParent()
        explosion.run(SKAction.sequence([animate, removeNode]))
    }
}
