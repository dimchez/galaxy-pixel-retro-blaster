//
//  GameScene.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-13.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var lastUpdateTime: TimeInterval = 0
    
    private var contactDelegate: ContactDelegate?
    
    private var backgroundMusic: SKAudioNode?
    
    lazy var stateMachine = GKStateMachine(states: [
        PlayingState(gameScene: self),
        PausedState(gameScene: self),
        GameOverState(gameScene: self)
    ])
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePause), name: .pauseGame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleResume), name: .resumeGame, object: nil)
        
        setupBackground()
        setupBackgroundMusic()
        
        stateMachine.enter(PlayingState.self)
        
        contactDelegate = ContactDelegate(for: self)
        physicsWorld.contactDelegate = self
    }
    
    @objc func handlePause() {
        isPaused = true
        stateMachine.enter(PausedState.self)
    }
    
    @objc func handleResume() {
        if stateMachine.currentState is PausedState && isPaused == false {
            isPaused = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        if let playingState = stateMachine.currentState as? PlayingState {
            playingState.touchesBegan(atPoint: touchLocation, atTime: CACurrentMediaTime())
        } else if let pausedState = stateMachine.currentState as? PausedState {
            pausedState.touchesBegan(at: touchLocation)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        if let playingState = stateMachine.currentState as? PlayingState {
            playingState.touchesMoved(toPoint: touchLocation, atTime: CACurrentMediaTime())
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let playingState = stateMachine.currentState as? PlayingState {
            playingState.touchesEnded()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Don't perform any updates if the scene isn't in a view.
        guard view != nil else { return }
        
        if self.isPaused { return }
        
        stateMachine.update(deltaTime: currentTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        contactDelegate?.didBegin(contact)
    }
    
    private func setupBackground() {
        let background = InfiniteScrollingBackground(size: frame.size)
        addChild(background)
    }
    
    private func setupBackgroundMusic() {
        let backgroundMusic = SKAudioNode(fileNamed: "backgroundMusic.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        self.backgroundMusic = backgroundMusic
        
        let volume = Settings.shared.getMusicVolume()
        let changeVolume = SKAction.changeVolume(to: volume, duration: 0)
        self.backgroundMusic?.run(SKAction.sequence([changeVolume, SKAction.play()]))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
