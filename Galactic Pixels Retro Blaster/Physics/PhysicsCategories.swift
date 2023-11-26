//
//  PhysicsCategories.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-17.
//

struct PhysicsCategories {
    static let none: UInt32             = 0
    static let player: UInt32           = 0x1
    static let enemy: UInt32            = 0x1 << 1
    static let bullet: UInt32           = 0x1 << 2
    static let asteroid: UInt32         = 0x1 << 3
    static let asteroidSmall: UInt32    = 0x1 << 4
}
