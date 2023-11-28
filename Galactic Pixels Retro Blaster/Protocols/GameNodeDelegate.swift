//
//  GameNodeDelegate.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-28.
//

import SpriteKit

enum GameNode {
    case asteroid
    case asteroidSmall
    case enemy
    case player
}

protocol GameNodeDelegate: AnyObject {
    func didGetDestroyed(nodeOfType gameNode: GameNode)
}
