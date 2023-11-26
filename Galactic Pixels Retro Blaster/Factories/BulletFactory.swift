//
//  BulletFactory.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-18.
//

import SpriteKit

class BulletFactory {
    static let shared = BulletFactory()
    
    static let atlas = SKTextureAtlas(named: "Bullet")
    
    static let textureFrames: [SKTexture] = {
        var frames: [SKTexture] = []
        let textureNames = BulletFactory.atlas.textureNames.sorted()
        
        for textureName in textureNames {
            let texture = BulletFactory.atlas.textureNamed(textureName)
            frames.append(texture)
        }
        
        return frames
    }()
    
    func spawnBullet() -> Bullet {
        let bullet = Bullet()
        
        if let initialTexture = BulletFactory.textureFrames.first {
            bullet.texture = initialTexture
            bullet.size = initialTexture.size()
        }
        
        bullet.setupAnimation(with: BulletFactory.textureFrames)
        bullet.setupPhysicsBody()
        
        return bullet
    }
}
