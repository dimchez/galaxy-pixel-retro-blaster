//
//  PausedState.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-14.
//

import SpriteKit
import GameplayKit

class PausedState: GKState {
    unowned let gameScene: GameScene
    
    let overlayColor = UIColor(red: 0, green: 4.0/255.0, blue: 24.0/255.0, alpha: 0.5)
    
    private var overlay: SKSpriteNode?
    
    private var resumeLabel: SKLabelNode?
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    override func didEnter(from previousState: GKState?) {
        gameScene.isPaused = true
        
        setupOverlay()
        setupResumeLabel()
    }
    
    override func willExit(to nextState: GKState) {
        overlay?.removeFromParent()
        gameScene.isPaused = false
    }
    
    func touchesBegan(at point: CGPoint) {
        let touchedNode = gameScene.atPoint(point)
        
        if touchedNode.name == "resume" {
            gameScene.stateMachine.enter(PlayingState.self)
        }
    }
    
    private func setupOverlay() {
        let overlay = SKSpriteNode(color: overlayColor, size: gameScene.size)
        overlay.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        overlay.zPosition = 10
        gameScene.addChild(overlay)
        
        self.overlay = overlay
    }
    
    private func setupResumeLabel() {
        let resumeLabel = SKLabelNode(fontNamed: "04B03")
        resumeLabel.name = "resume"
        resumeLabel.text = "Resume"
        resumeLabel.fontSize = 96
        resumeLabel.fontColor = SKColor.white
        resumeLabel.position = CGPoint.zero
        overlay?.addChild(resumeLabel)
        
        self.resumeLabel = resumeLabel
    }
}
