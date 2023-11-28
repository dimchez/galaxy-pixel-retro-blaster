//
//  PlayingState.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-14.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState, GameNodeDelegate {
    unowned let gameScene: GameScene
    
    var camera: SKCameraNode?
    
    var player: Player?
    
    var gameSpeed: CGFloat = 5.0
    
    var lastUpdateTime: TimeInterval = 0
    
    var levelUpScore = 100
    
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
            setupCamera()
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
    
    func didGetDestroyed(nodeOfType gameNode: GameNode) {
        switch gameNode {
        case .asteroid:
            increaseScore(by: 5)
        case .asteroidSmall:
            increaseScore(by: 2)
        case .enemy:
            increaseScore(by: 1)
        case .player:
            shakeCamera(forDuration: 0.5)
        }
    }
    
    func enemyDidGetDestroyed() {
        increaseScore(by: 1)
    }
    
    private func setupPlayer() {
        let playerCharacter = Player()

        gameScene.addChild(playerCharacter)
        
        playerCharacter.resetPosition(in: gameScene)
        playerCharacter.makeInvulnurable()
        
        player = playerCharacter
        player?.delegate = self
    }
    
    private func setupCamera() {
        let camera = SKCameraNode()
        gameScene.addChild(camera)
        gameScene.camera = camera
        camera.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        
        self.camera = camera
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
        
        if score < levelUpScore && newScore >= levelUpScore {
            player?.levelUp()
            levelUpScore *= 2
        }
        
        score = newScore
    }
    
    private func shakeCamera(forDuration duration: TimeInterval) {
        let amplitudeX: Float = 16
        let offsetX = amplitudeX / 2
        
        let amplitudeY: Float = 12
        let offsetY = amplitudeY / 2
        
        var actions: [SKAction] = []
        
        let numberOfShakes = Int(duration / 0.04)
        
        for _ in 1...numberOfShakes {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - offsetX
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - offsetY
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02)
            shakeAction.timingMode = .easeOut
            actions.append(shakeAction)
            actions.append(shakeAction.reversed())
        }
        
        let actionsSequence = SKAction.sequence(actions)
        camera?.run(actionsSequence)
    }
}
