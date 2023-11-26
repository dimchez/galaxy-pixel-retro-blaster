//
//  Updatable.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-19.
//

import SpriteKit

protocol Updatable: AnyObject {
    func update(deltaTime: TimeInterval)
}
