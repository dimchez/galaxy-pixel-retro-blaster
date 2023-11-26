//
//  SoundManager.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-26.
//

import SpriteKit

enum SoundFX {
    case explosion
    case bulletHit
}

class SoundEffects {
    
    static let shared = SoundEffects()
    
    private let explosion = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    private let bulletHit = SKAction.playSoundFileNamed("bulletHit.wav", waitForCompletion: false)
    
    func play(_ soundFx: SoundFX, in scene: SKScene) {
        switch soundFx {
        case .explosion:
            scene.run(explosion)
        case .bulletHit:
            scene.run(bulletHit)
        }
    }
}
