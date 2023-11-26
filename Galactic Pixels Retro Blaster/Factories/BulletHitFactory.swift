//
//  BulletHitFactory.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-19.
//

import SpriteKit

class BulletHitFactory {
    static let shared = BulletHitFactory()
    
    static let atlas = SKTextureAtlas(named: "Hit")
    
    static let textureFrames: [SKTexture] = {
        var frames: [SKTexture] = []
        let textureNames = BulletHitFactory.atlas.textureNames.sorted()
        
        for textureName in textureNames {
            let texture = BulletHitFactory.atlas.textureNamed(textureName)
            frames.append(texture)
        }
        
        return frames
    }()
    
    func playBulletHit(at position: CGPoint, in scene: SKScene) {
        guard let firstFrame = BulletHitFactory.textureFrames.first else { return }
        
        let hit = SKSpriteNode(texture: firstFrame)
        hit.position = position
        scene.addChild(hit)
        
        let animate = SKAction.animate(with: BulletHitFactory.textureFrames, timePerFrame: 0.01)
        let removeNode = SKAction.removeFromParent()
        hit.run(SKAction.sequence([animate, removeNode]))
        
        SoundEffects.shared.play(.bulletHit, in: scene)
    }
}
