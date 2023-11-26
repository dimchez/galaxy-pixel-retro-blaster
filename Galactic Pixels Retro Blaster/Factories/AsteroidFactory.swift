//
//  AsteroidFactory.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-21.
//

import SpriteKit

class AsteroidFactory {
    
    static let shared = AsteroidFactory()
    
    private let largeAndroidTexture = SKTexture(imageNamed: "asteroid")
    
    private let smallAsteroidTexture = SKTexture(imageNamed: "asteroid-small")
    
    private var lastSpawnedAsteroidPosition = CGPoint.zero
    
    private var nextAsteroidDirection = AsteroidDirection.downward
    
    func spawnAsteroid(in frame: CGRect) -> Asteroid {
        let asteroid = Asteroid(largeAndroidTexture, withDirection: nextAsteroidDirection)
        
        asteroid.position = getRandomPositionFor(asteroid: asteroid, in: frame)
        
        lastSpawnedAsteroidPosition = asteroid.position
        nextAsteroidDirection.toggle()
        
        return asteroid
    }
    
    func spawnAsteroid(from direction: CGFloat, and velocity: CGVector, at position: CGPoint) -> AsteroidSmall {
        let newVelocity = calculateNewVelocity(from: velocity, and: direction)
        let asteroid = AsteroidSmall(fromTexture: smallAsteroidTexture, withVelocity: newVelocity, andPosition: position)
        return asteroid
    }
    
    private func getRandomPositionFor(asteroid: Asteroid, in frame: CGRect) -> CGPoint {
        let minX = frame.midX
        let maxX = frame.maxX - asteroid.size.width * 1.5
        
        let randomX = CGFloat.random(in: minX...maxX)
        let y = nextAsteroidDirection == .downward ? frame.maxY + asteroid.size.height : frame.minY - asteroid.size.height
        
        let position = CGPoint(x: randomX, y: y)
        lastSpawnedAsteroidPosition = position
        
        return position
    }
    
    private func calculateNewVelocity(from velocity: CGVector, and direction: CGFloat) -> CGVector {
        let newAngle = atan2(velocity.dy, velocity.dx) + direction
        let speed = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
        return CGVector(dx: cos(newAngle) * speed, dy: sin(newAngle) * speed)
    }
}
