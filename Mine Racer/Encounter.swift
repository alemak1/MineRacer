//
//  Encounter.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import GameplayKit



class EncounterSeries{
    
    var firstEncounter: Encounter
    var planeViewController: PlaneViewController
    
    var currentEncounter: Encounter?{
        didSet{
            if(currentEncounter != nil){
                executeEncounter()
            }
        }
    }
    
    var totalSeriesTime: Double{
        return getEncounterTime()
    }
    
    private func getEncounterTime() -> Double{
        
        var time = self.firstEncounter.waitTime
        
        if let nextEncounter = self.firstEncounter.getNextEncounter(){
            
            time += nextEncounter.waitTime
            
            return getEncounterTime()
            
        } else {
            return time
        }
        
    }
    
    init(planeViewController: PlaneViewController, firstEncounter: Encounter) {
        self.firstEncounter = firstEncounter
        self.planeViewController = planeViewController
    }
    
    func start(){
        self.currentEncounter = self.firstEncounter
    }
    
    
    func executeEncounter(){
        
        if(self.currentEncounter == nil){
            return
        }
        
        let waitTime = self.currentEncounter!.waitTime
        
        DispatchQueue.global().asyncAfter(deadline: .now() + waitTime, execute: {
            
            
            self.addGameObjects()
            
            if let nextEncounter = self.currentEncounter!.getNextEncounter(){
                self.currentEncounter = nextEncounter
        
            }
            
        })
    }
    
    private func addGameObjects(){
        if let obstacles = self.currentEncounter!.obstacles{
            
        }
        
        if let enemies = self.currentEncounter!.enemies{
            
        }
        
        if let letterRings = self.currentEncounter!.letterRings{
            planeViewController.letterRingManager.addLetterRings(letterRings: letterRings)
        }
        
        
    }
}

class Encounter{
    
    var nextEncounter: Encounter?
    
    var waitTime: Double = 5.00
    
    var obstacles: [SCNNode]?
    var enemies: [SCNNode]?
    var letterRings: [LetterRing]?
    
    init(waitTime: Double, obstacles: [SCNNode]?, enemies: [SCNNode]?, letterRings: [LetterRing]?){
        
        self.waitTime = waitTime
        self.obstacles = obstacles
        self.enemies = enemies
        self.letterRings = letterRings
        
        nextEncounter = nil
    }
    
    func setNextEncounter(waitTime: Double, obstacles: [SCNNode]?, enemies: [SCNNode]?, letterRings: [LetterRing]?) -> Encounter{
        
        self.nextEncounter = Encounter(waitTime: waitTime, obstacles: obstacles, enemies: enemies, letterRings: letterRings)
        
        return self.nextEncounter!
    }
    
    func getNextEncounter() -> Encounter?{
        
        return nextEncounter
    }
}
