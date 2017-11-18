//
//  AudioManager.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/18/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class AudioManager{
    
    static let sharedInstance = AudioManager()
    
    enum SoundType{
        case gameWin,gameLoss,acquireLetter,gameStart,planeHit
    }
    
    var planeHitSounds = [SCNAudioSource]()
    var gameWinSounds = [SCNAudioSource]()
    var gameLossSounds = [SCNAudioSource]()
    var acquireLetterSounds = [SCNAudioSource]()
    var gameStartSounds = [SCNAudioSource]()
    
    private init() {
        loadSounds()
    }
    
    
    
    func addSound(ofType soundType: SoundType, toNode gameNode: SCNNode, removeAfter numberSeconds: Double?){
        
        if(!gameWinSounds.isEmpty && gameWinSounds.count > 0){
            
            var gameWinAudioSrc: SCNAudioSource?
            
            switch soundType{
            case .acquireLetter:
                gameWinAudioSrc = acquireLetterSounds.getRandomElement() as? SCNAudioSource
                break
            case .gameLoss:
                gameWinAudioSrc = gameLossSounds.getRandomElement() as? SCNAudioSource
                break
            case .gameWin:
                gameWinAudioSrc = gameWinSounds.getRandomElement() as? SCNAudioSource
                break
            case .gameStart:
                gameWinAudioSrc = gameStartSounds.getRandomElement() as? SCNAudioSource
                break
            case .planeHit:
                gameWinAudioSrc = planeHitSounds.getRandomElement() as? SCNAudioSource
                break
            }
            
            guard let audioSrc = gameWinAudioSrc else {
                print("Error: failed to obtain requested audio src")
                return
            }
            
            let audioPlayer = SCNAudioPlayer(source: audioSrc)
            gameNode.addAudioPlayer(audioPlayer)
        
            if let seconds = numberSeconds{
                
                gameNode.runAction(SCNAction.sequence([
                    SCNAction.wait(duration: TimeInterval(seconds)),
                    SCNAction.run({_ in
                        gameNode.removeAudioPlayer(audioPlayer)
                    })
                    ]))
            }
        }
    }
    
    func loadSounds(){
        loadPlaneHitSound(withFileName: "hitHelmet1.wav")
        loadPlaneHitSound(withFileName: "hitHelmet2.wav")
        loadPlaneHitSound(withFileName: "hitHelmet3.wav")
        loadPlaneHitSound(withFileName: "hitHelmet4.wav")
        loadPlaneHitSound(withFileName: "hitHelmet5.wav")
        
        loadGameWinSound(withFileName: "you_win.wav")
        loadGameWinSound(withFileName: "objective_achieved.wav")
        
        loadGameLoseSound(withFileName: "you_lose.wav")
        
        loadGameStartSound(withFileName: "prepare_yourself.wav")
        
        loadAcquireLetterSound(withFileName: "power_up.wav")
        loadAcquireLetterSound(withFileName: "jump1.wav")

    }
    
    
    func loadAcquireLetterSound(withFileName fileName: String){
        if let sound = SCNAudioSource(fileNamed: fileName){
            planeHitSounds.append(sound)
        }
    }
    
    func loadGameStartSound(withFileName fileName: String){
        if let sound = SCNAudioSource(fileNamed: fileName){
            gameStartSounds.append(sound)
        }
    }
    
    func loadGameLoseSound(withFileName fileName: String){
        if let sound = SCNAudioSource(fileNamed: fileName){
            gameLossSounds.append(sound)
        }
    }
    
    func loadGameWinSound(withFileName fileName: String){
        if let sound = SCNAudioSource(fileNamed: fileName){
            gameWinSounds.append(sound)
        }
    }
    
    func loadPlaneHitSound(withFileName fileName: String){
        if let sound = SCNAudioSource(fileNamed: fileName){
            planeHitSounds.append(sound)
        }
        
    }
}
