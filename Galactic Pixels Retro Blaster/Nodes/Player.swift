//
//  Player.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-15.
//

import SpriteKit

enum Orientation {
    case upwards
    case neutral
    case downwards
}

class Player: SKSpriteNode {
    
    static let name = "player"
    
    weak var delegate: GameNodeDelegate?
    
    private var orientation: Orientation = .neutral {
        didSet {
            texture = textureForOrientation(orientation)
        }
    }
    
    private var lastTouchPosition: CGPoint?
    
    private var lastUpdateTime: TimeInterval?
    
    private var muzzleFlash: MuzzleFlash?
    
    private var isShooting = false
    
    private var level = 1
    
    private let verticalSpeedThreshold: CGFloat = 1000.0 // Vertical speed threshold in points per second
    
    private let neutralTexture = SKTexture(imageNamed: "player1")
    
    private let upwardsTexture = SKTexture(imageNamed: "player3")
    
    private let downwardsTexture = SKTexture(imageNamed: "player2")
    
    private static let levelUpAtlas = SKTextureAtlas(named: "LevelUp")
    
    private static let levelUpTextureFrames: [SKTexture] = {
        var frames: [SKTexture] = []
        let textureNames = levelUpAtlas.textureNames.sorted()
        
        for textureName in textureNames {
            let texture = levelUpAtlas.textureNamed(textureName)
            texture.filteringMode = .nearest
            frames.append(texture)
        }
        
        return frames
    }()
    
    init() {
        super.init(texture: neutralTexture, color: .clear, size: neutralTexture.size())
        self.name = Player.name
        
        setupPhysicsBody()
        setupMuzzleFlash()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveTo(toPoint position: CGPoint, atTime currentTime: TimeInterval, in scene: SKScene) {
        guard let lastTouch = lastTouchPosition else { return }
        
        let movementDelta = position - lastTouch
        
        movePlayerBy(by: movementDelta, in: scene)
        updateOrientation(by: movementDelta, atTime: currentTime)
        
        lastTouchPosition = position
        lastUpdateTime = currentTime
    }
    
    func touchesBegan(atPoint position: CGPoint, atTime currentTime: TimeInterval) {
        lastTouchPosition = position
        lastUpdateTime = currentTime
        
        startShoooting()
    }
    
    func touchesEnded() {
        orientation = .neutral
        stopShooting()
    }
    
    func explode(in scene: SKScene) {
        stopShooting()
        
        ExplosionFactory.shared.playExplosion(at: position, in: scene)
        SoundEffects.shared.play(.explosion, in: scene)
        
        delegate?.didGetDestroyed(nodeOfType: .player)
    }
    
    func resetPosition(in scene: SKScene) {
        position = CGPoint(x: -size.width, y: scene.frame.midY)
    }
    
    func makeInvulnurable() {
        physicsBody?.categoryBitMask = PhysicsCategories.none
        
        let resetPosition = SKAction.moveTo(x: -size.width, duration: 0)
        let moveInAction = SKAction.moveBy(x: size.width * 3, y: 0, duration: 0.5)
        moveInAction.timingMode = .easeInEaseOut
        
        let blinkAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.1),
            SKAction.fadeIn(withDuration: 0.1)
        ]))
        
        run(SKAction.group([
            resetPosition,
            moveInAction,
            blinkAction
        ]), withKey: "blinking")
        
        let waitAction = SKAction.wait(forDuration: 1.5)
        let restoreAction = SKAction.run {
            self.removeAction(forKey: "blinking")
            self.alpha = 1.0
            self.physicsBody?.categoryBitMask = PhysicsCategories.player
        }
        
        run(SKAction.sequence([waitAction, restoreAction]))
    }
    
    func startShoooting() {
        isShooting = true
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run { [weak self] in self?.fireBullet() },
                SKAction.wait(forDuration: 0.4) // 4 shots per second
            ])
        ), withKey: "shooting")
    }
    
    func stopShooting() {
        isShooting = false
        removeAction(forKey: "shooting")
    }
    
    func levelUp() {
        level += 1
        showLevelUpEffect()
    }
    
    private func setupPhysicsBody() {
        guard let texture = self.texture else { return }
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = PhysicsCategories.player
        physicsBody?.contactTestBitMask = PhysicsCategories.enemy | PhysicsCategories.asteroid
        physicsBody?.collisionBitMask = PhysicsCategories.none
        physicsBody?.affectedByGravity = false
    }
    
    private func setupMuzzleFlash() {
        let flash = MuzzleFlash(atPoint: CGPoint(x: size.width / 2, y: 0))
        addChild(flash)
        
        muzzleFlash = flash
    }
    
    private func movePlayerBy(by delta: CGPoint, in scene: SKScene) {
        var newPosition = position
        newPosition += delta
        
        newPosition.x = newPosition.x.clamp(min: size.width, max: scene.size.width - size.width)
        newPosition.y = newPosition.y.clamp(min: size.height, max: scene.size.height - size.height)
        
        position = newPosition
    }
    
    private func updateOrientation(by delta: CGPoint, atTime currentTime: TimeInterval) {
        guard let lastTime = lastUpdateTime else { return }
        
        let timeDelta = currentTime - lastTime
        let verticalSpeed = abs(delta.y) / CGFloat(timeDelta)
        
        if verticalSpeed > verticalSpeedThreshold {
            if delta.y > 0 {
                orientation = .upwards
            } else if delta.y < 0 {
                orientation = .downwards
            }
        } else if (orientation == .downwards && delta.y > 0) || (orientation == .upwards && delta.y < 0) {
            // Change to neutral if moving slowly in the opposite direction
            orientation = .neutral
            
        }
    }
    
    private func textureForOrientation(_ orientation: Orientation) -> SKTexture {
        switch orientation {
        case .upwards:
            return upwardsTexture
        case .downwards:
            return downwardsTexture
        case .neutral:
            return neutralTexture
        }
    }
    
    private func fireBullet() {
        let bullet = BulletFactory.shared.spawnBullet(level: level)
        
        let direction = CGVector(dx: 1000, dy: 0)
        let offset = CGPoint(x: size.width / 2 + bullet.size.width / 2, y: 0)
        let from = position + offset
        
        bullet.fire(from: from, direction: direction)
        
        muzzleFlash?.flash()
        parent?.addChild(bullet)
    }
    
    func showLevelUpEffect() {
        guard let firstFrame = Player.levelUpTextureFrames.first else { return }
        
        let levelUp = SKSpriteNode(texture: firstFrame, size: firstFrame.size())
        levelUp.position = CGPoint.zero
        levelUp.zPosition = 10
        addChild(levelUp)
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0)
        let animate = SKAction.repeatForever(SKAction.animate(with: Player.levelUpTextureFrames, timePerFrame: 0.05, resize: true, restore: true))
        let scaleUp = SKAction.scale(by: 10, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let animateRepeat = SKAction.repeatForever(SKAction.group([fadeIn, animate, scaleUp, fadeOut]))
        
        let wait = SKAction.wait(forDuration: 5.0)
        let removeNode = SKAction.removeFromParent()
        
        levelUp.run(SKAction.sequence([animateRepeat, wait, removeNode]))
    }
}
