//
//  InfiniteScrollingBackground.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-14.
//

import SpriteKit

class InfiniteScrollingBackground: SKNode {
    private let backgroundTexture = SKTexture(imageNamed: "background")
    
    private let starsTexture = SKTexture(imageNamed: "stars")
    
    private let planetTexture = SKTexture(imageNamed: "planet")
    
    init(size: CGSize) {
        super.init()
        setupNebulaBackground(size: size)
        setupPlanetBackground(size: size)
        setupStarfieldBackground(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNebulaBackground(size: CGSize) {
        setupBackground(texture: backgroundTexture, size: size, zPosition: -40, moveBy: 180)
    }
    
    func setupPlanetBackground(size: CGSize) {
        let planet = SKSpriteNode(texture: planetTexture)
        
        planet.scale(to: size)
        
        planet.zPosition = -20
        planet.anchorPoint = CGPoint.zero
        planet.position = CGPoint(x: planet.size.width, y: 0)
        
        addChild(planet)
        
        let moveLeft = SKAction.moveBy(x: -planet.size.width * 2, y: 0, duration: 80)
        let resetPosition = SKAction.moveBy(x: planet.size.width * 2, y: 0, duration: 0)
        let moveSequence = SKAction.sequence([moveLeft, resetPosition])
        let moveForever = SKAction.repeatForever(moveSequence)
        
        planet.run(moveForever)
    }
    
    func setupStarfieldBackground(size: CGSize) {
        setupBackground(texture: starsTexture, size: size, zPosition: -30, moveBy: 120)
    }
    
    func setupBackground(texture: SKTexture, size: CGSize, zPosition: CGFloat, moveBy duration: TimeInterval) {
        for i in 0...1 {
            let background = SKSpriteNode(texture: texture)
            
            background.scale(to: size)
            
            background.zPosition = zPosition
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: background.size.width * CGFloat(i), y: 0)
            
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -background.size.width, y: 0, duration: duration)
            let resetPosition = SKAction.moveBy(x: background.size.width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, resetPosition])
            let moveForever = SKAction.repeatForever(moveSequence)
            
            background.run(moveForever)
        }
    }
}
