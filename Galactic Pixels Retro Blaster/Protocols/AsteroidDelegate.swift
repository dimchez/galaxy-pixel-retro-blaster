//
//  AsteroidDelegate.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-22.
//

import SpriteKit

protocol AsteroidDelegate: AnyObject {
    func asteroidDidGetDestroyed(ofSize size: AsteroidSize)
}

enum AsteroidSize {
    case small
    case large
}

enum AsteroidDirection: Int {
    case upward = 1
    case downward = -1
    
    mutating func toggle() {
        self = self == .downward ? .upward : .downward
    }
}
