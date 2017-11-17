//
//  EncounterTimer.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/16/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

class EncounterTimer{
    
    var timer: Timer
    var firstEncounter: Encounter
    var currentEncounter: Encounter?
    var planeViewController: PlaneViewController
    
    init(planeViewController: PlaneViewController, firstEncounter: Encounter){
        
        self.firstEncounter = firstEncounter
        self.planeViewController = planeViewController
        self.timer = Timer()
        
        /**
        self.timer = Timer(timeInterval: 3.00, repeats: true, block: {
            
            _ in
            
            if(self.currentEncounter == nil){
                return
            }
            
            if let numberOfSpikeBalls = self.currentEncounter!.numberOfSpikeBalls{
                self.planeViewController.spikeBallManager.addRandomSpikeBalls(number: numberOfSpikeBalls)
            }
            
            if let numberOfSpaceCraft = self.currentEncounter!.numberOfSpaceCraft{
                self.planeViewController.spaceCraftManager.addRandomSpaceCraft(number: numberOfSpaceCraft)
            }
            
            if let numberOfLetters = self.currentEncounter!.numberOfLetters{
                
                self.planeViewController.letterRingManager.addRandomizedMovingRing(with: numberOfLetters, fromWord: self.planeViewController.currentWord)
            }
            
            if let numberOfFireballs = self.currentEncounter!.numberOfFireballs{
                self.planeViewController.fireballManager.addRandomFireballs(number: numberOfFireballs)
            }
            
            if let numberOfTurrets = self.currentEncounter!.numberOfTurrets{
                self.planeViewController.turretManager.addRandomTurrets(number: numberOfTurrets)
            }
            
            self.currentEncounter! = self.currentEncounter!.getNextEncounter()!
        })
         **/
    }
    
    func setupTimer(){
        
        timer = Timer(timeInterval: 3.00, target: self, selector: #selector(generateEncounter), userInfo: nil, repeats: true)
    }
    
    func startGeneratingEnemies(){
     
        
        timer.fire()
    }
    
    func stopGeneratingEnemies(){
        timer.invalidate()
    }
    
    @objc func generateEncounter(){
        
    }
}
