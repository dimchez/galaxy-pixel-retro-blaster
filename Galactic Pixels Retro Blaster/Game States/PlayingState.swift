//
//  PlayingState.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-14.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState, EnemyDelegate, AsteroidDelegate {
    unowned let gameScene: GameScene
    
    var player: Player?
    
    var gameSpeed: CGFloat = 5.0
    
    var lastUpdateTime: TimeInterval = 0
    
    var scoreLabel: SKLabelNode?
    
    var score = 0 {
        didSet {
            updateScoreLabel()
        }
    }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState == nil {
            setupPlayer()
        }
        
        initSpawnEnemies()
        initSpawnAsteroids()
        
        lastUpdateTime = CACurrentMediaTime()
        
        scoreLabel = gameScene.childNode(withName: "//scoreLabel") as? SKLabelNode
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let deltaTime = seconds - lastUpdateTime
        
        gameScene.children.compactMap({ $0 as? Updatable }).forEach { updatableNode in
            updatableNode.update(deltaTime: deltaTime)
        }
        
        increaseGameSpeed()
        
        lastUpdateTime = seconds
    }
    
    func touchesBegan(atPoint position: CGPoint, atTime currentTime: TimeInterval) {
        player?.touchesBegan(atPoint: position, atTime: currentTime)
    }
    
    func touchesMoved(toPoint position: CGPoint, atTime currentTime: TimeInterval) {
        player?.moveTo(toPoint: position, atTime: currentTime, in: gameScene)
    }
    
    func touchesEnded() {
        player?.touchesEnded()
    }
    
    func enemyDidGetDestroyed() {
        increaseScore(by: 1)
    }
    
    func asteroidDidGetDestroyed(ofSize size: AsteroidSize) {
        switch size {
        case .small:
            increaseScore(by: 2)
        case .large:
            increaseScore(by: 5)
        }
    }
    
    private func setupPlayer() {
        let playerCharacter = Player()

        gameScene.addChild(playerCharacter)
        
        playerCharacter.resetPosition(in: gameScene)
        playerCharacter.makeInvulnurable()
        
        player = playerCharacter
    }
    
    private func initSpawnEnemies() {
        let waitAfterStart = SKAction.wait(forDuration: 1.0)
        let spawnEnemySequence = SKAction.sequence([
            SKAction.run(spawnEnemy),
            SKAction.wait(forDuration: 3.0)
        ])
        let spawnEnemyRepeat = SKAction.repeatForever(spawnEnemySequence)
        let spawnEnemyActions = SKAction.sequence([waitAfterStart, spawnEnemyRepeat])
        
        gameScene.run(spawnEnemyActions)
    }
    
    private func initSpawnAsteroids() {
        let waitAfterStart = SKAction.wait(forDuration: 10.0)
        let spawnAsteroidSequence = SKAction.sequence([
            SKAction.run(spawnAsteroid),
            SKAction.wait(forDuration: 10.0)
        ])
        let spawnAsteroidRepeat = SKAction.repeatForever(spawnAsteroidSequence)
        let spawnAsteroidActions = SKAction.sequence([waitAfterStart, spawnAsteroidRepeat])
        
        gameScene.run(spawnAsteroidActions)
    }
    
    private func spawnEnemy() {
        let enemy = EnemyFactory.shared.spawnEnemy(in: gameScene.frame)
        enemy.delegate = self
        
        gameScene.addChild(enemy)
    }
    
    private func spawnAsteroid() {
        let asteroid = AsteroidFactory.shared.spawnAsteroid(in: gameScene.frame)
        asteroid.delegate = self
        gameScene.addChild(asteroid)
    }
    
    private func increaseGameSpeed() {
        gameSpeed += 0.1
    }
    
    private func updateScoreLabel() {
        let formattedScore = String(format: "%05d", score)
        scoreLabel?.text = "Score: \(formattedScore)"
    }
    
    private func increaseScore(by delta: Int) {
        let newScore = score + delta
        
        // TODO: increase amount required to level up
        if score < 10 && newScore >= 10 {
            player?.levelUp()
        }
        
        score = newScore
    }
}
