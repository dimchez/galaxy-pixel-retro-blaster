//
//  TitleScene.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-13.
//

import SpriteKit

class TitleScene: SKScene {
    
    private let fadeColor = UIColor(red: 0, green: 4.0/255.0, blue: 24.0/255.0, alpha: 1.0)
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupBackgroundMusic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode.name == "startGameButton" {
            let scaleDown = SKAction.scale(by: 0.9, duration: 0.2)
            let fadeAlpha = SKAction.fadeAlpha(to: 0.5, duration: 0.2)
            
            touchedNode.run(SKAction.group([scaleDown, fadeAlpha]))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode.name == "startGameButton" {
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.2)
            let fadeAlpha = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
            
            touchedNode.run(SKAction.group([scaleUp, fadeAlpha])) {
                self.movePlayerOffScreen()
            }
        }
    }
    
    func movePlayerOffScreen() {
        guard let player = self.childNode(withName: "player") as? SKSpriteNode else { return }
        
        let moveOut = SKAction.moveTo(x: size.width + player.size.width,  duration: 1.0)
        moveOut.timingMode = .easeIn
        
        player.run(moveOut) {
            self.transitionToNextScene()
        }
    }
    
    func transitionToNextScene() {
        guard let gameScene = SKScene(fileNamed: "GameScene") else { return }
        
        gameScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(with: self.fadeColor, duration: 1)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    private func setupBackground() {
        let background = InfiniteScrollingBackground(size: frame.size)
        addChild(background)
    }
    
    private func setupBackgroundMusic() {
        let backgroundMusic = SKAudioNode(fileNamed: "backgroundMusic.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        let volume = Settings.shared.getMusicVolume()
        let changeVolume = SKAction.changeVolume(to: volume, duration: 0)
        backgroundMusic.run(SKAction.sequence([changeVolume, SKAction.play()]))
    }
}
