//
//  BulletFactory.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-18.
//

import SpriteKit

class BulletFactory {
    static let shared = BulletFactory()
    
    static let bulletAtlas = SKTextureAtlas(named: "Bullet")
    
    static let sparkAtlas = SKTextureAtlas(named: "Spark")
    
    static let bulletTextureFrames: [SKTexture] = {
        var frames: [SKTexture] = []
        let textureNames = BulletFactory.bulletAtlas.textureNames.sorted()
        
        for textureName in textureNames {
            let texture = BulletFactory.bulletAtlas.textureNamed(textureName)
            frames.append(texture)
        }
        
        return frames
    }()
    
    static let sparkTextureFrames: [SKTexture] = {
        var frames: [SKTexture] = []
        let textureNames = BulletFactory.sparkAtlas.textureNames.sorted()
        
        for textureName in textureNames {
            let texture = BulletFactory.sparkAtlas.textureNamed(textureName)
            frames.append(texture)
        }
        
        return frames
    }()
    
    func spawnBullet(level: Int) -> Bullet {
        switch level {
        case 2:
            return spawnSpark()
        default:
            return spawnBullet()
        }
    }
    
    private func spawnBullet() -> Bullet {
        let bullet = Bullet()
        
        if let initialTexture = BulletFactory.bulletTextureFrames.first {
            bullet.texture = initialTexture
            bullet.size = initialTexture.size()
        }
        
        bullet.setupAnimation(with: BulletFactory.bulletTextureFrames)
        bullet.setupPhysicsBody()
        bullet.run(SKAction.scale(by: 4, duration: 2.0))
        
        return bullet
    }
    
    private func spawnSpark() -> Bullet {
        let bullet = Bullet()
        
        if let initialTexture = BulletFactory.sparkTextureFrames.first {
            bullet.texture = initialTexture
            bullet.size = initialTexture.size()
        }
        
        bullet.setupAnimation(with: BulletFactory.sparkTextureFrames)
        bullet.setupPhysicsBody()
        bullet.damageMultiplier = 1.2
        bullet.run(SKAction.scale(by: 8, duration: 1.5))
        
        return bullet
    }
}
