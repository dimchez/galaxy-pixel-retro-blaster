//
//  Settings.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-26.
//

import Foundation

class Settings {
    static let shared = Settings()
    
    private let musicVolumeKey = "musicVolume"
    
    func initDefaultValues() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: musicVolumeKey) == nil {
            defaults.setValue(0.5, forKey: musicVolumeKey)
        }
    }
    
    func getMusicVolume() -> Float{
        UserDefaults.standard.float(forKey: musicVolumeKey)
    }
}
