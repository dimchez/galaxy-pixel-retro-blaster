//
//  EnemyFactory.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-16.
//

import SpriteKit

class EnemyFactory {
    static let shared = EnemyFactory()
    
    static let atlas = SKTextureAtlas(named: "Enemy")
    
    static let textureFrames: [SKTexture] = {
        var frames: [SKTexture] = []
        let textureNames = EnemyFactory.atlas.textureNames.sorted()
        
        for textureName in textureNames {
            let texture = EnemyFactory.atlas.textureNamed(textureName)
            frames.append(texture)
        }
        
        return frames
    }()
    
    private var lastSpawnedEnemyPosition: CGPoint = CGPoint.zero
    
    func spawnEnemy(in frame: CGRect) -> Enemy {
        let enemy = Enemy()
        
        if let initialTexture = EnemyFactory.textureFrames.first {
            enemy.texture = initialTexture
            enemy.size = initialTexture.size()
        }
        
        enemy.setupAnimation(with: EnemyFactory.textureFrames)
        enemy.setupPhysicsBody()
        enemy.position = getRandomPositionFor(enemy: enemy, in: frame)
        
        return enemy
    }
    
    private func getRandomPositionFor(enemy: Enemy, in frame: CGRect) -> CGPoint {
        let minY = enemy.size.height
        let maxY = frame.maxY - enemy.size.height
        
        var randomY = CGFloat.random(in: minY...maxY)
        let positionX = frame.maxX + enemy.size.width
        var position = CGPoint(x: positionX, y: randomY)
        
        let maxAttempts = 3
        for _ in 1...maxAttempts {
            if !position.isWithinDistance(enemy.size.height, ofPoint: lastSpawnedEnemyPosition) {
                break
            }
            
            randomY = CGFloat.random(in: minY...maxY)
            position = CGPoint(x: positionX, y: randomY)
        }
        
        lastSpawnedEnemyPosition = position
        
        return position
    }
}
