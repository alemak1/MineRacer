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
            
            print("Current encounter has been set, executing nextencounter.....")

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
        print("Starting the encounter series....setting the first encounter...")
        self.currentEncounter = self.firstEncounter
    }
    
    
    func executeEncounter(){
        
        if(self.currentEncounter == nil){
            return
        }
        
        let waitTime = self.currentEncounter!.waitTime
        
        print("Preparing to execute next encounter....")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + waitTime, execute: {
            
            
            print("Adding game objects for encounter....")

            self.addGameObjects()
            
            
            print("Getting next encounter....")

            if let nextEncounter = self.currentEncounter!.getNextEncounter(){
                
                print("Setting next encounter....")

                self.currentEncounter = nextEncounter
        
            } else {
                print("No more encounters in series...")
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
        
        if let numberOfFireballs = self.currentEncounter!.numberOfFireballs{
            planeViewController.fireballManager.addRandomFireballs(number: numberOfFireballs)
        }
        
    }
}


extension EncounterSeries{
    static func GetFireballSeries1(planeViewController: PlaneViewController) -> EncounterSeries{
    
        let firstEncounter = Encounter(waitTime: 3.00, obstacles: nil, enemies: nil, letterRings: nil, numberOfFireballs: 2)
        
        
        let secondEncounter = firstEncounter.setNextEncounter(waitTime: 2.00, obstacles: nil, enemies: nil, letterRings: nil, numberOfFireballs: 4)
        

        let thirdEncounter = secondEncounter.setNextEncounter(waitTime: 4.0, obstacles: nil, enemies: nil, letterRings: nil, numberOfFireballs: 5)
        
        
        _ = thirdEncounter.setNextEncounter(waitTime: 4.00, obstacles: nil, enemies: nil, letterRings: nil, numberOfFireballs: 6)
        
        return EncounterSeries(planeViewController: planeViewController, firstEncounter: firstEncounter)
    }
    
    static func GenerateFireballEncounterSeries(forPlaneViewController planeViewController: PlaneViewController,withNumberOfEncounters numberOfEncounters: Int, withMaxFireballs maxFireballs: Int, withMaxWaitTime maxWaitTime: Int) -> EncounterSeries{
        
        if(numberOfEncounters < 2){
            fatalError("Error: there must be at least two encounters minimum in order for an encounter series to be generated")
        }
        
        let getMaxWaitTime = {
            
            return Double(5.00 + Double(arc4random_uniform(UInt32(maxWaitTime))))

        }
        
        
        
        let getRandomNumberOfFireballs: ()->Int = {
            
            let maximumNum = maxFireballs <= 0 ? 3: maxFireballs
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
            
        }
        
        let firstWaitTime = getMaxWaitTime()
        let fireballNum1 = getRandomNumberOfFireballs()
        
        let firstEncounter = Encounter(waitTime: firstWaitTime, obstacles: nil, enemies: nil, letterRings: nil, numberOfFireballs: fireballNum1)
        
        let secondWaitTime = getMaxWaitTime()
        let fireballNum2 = getRandomNumberOfFireballs()
    
        var nextEncounter = firstEncounter.setNextEncounter(waitTime: secondWaitTime, obstacles: nil, enemies: nil, letterRings: nil, numberOfFireballs: fireballNum2)
        
        for _ in 1..<numberOfEncounters-2{
            
            let nextWaitTime = getMaxWaitTime()
            let nextFireballNum = getRandomNumberOfFireballs()
            
            nextEncounter = nextEncounter.setNextEncounter(waitTime: nextWaitTime, obstacles: nil, enemies: nil, letterRings: nil, numberOfFireballs: nextFireballNum)
            
        }
        
        return EncounterSeries(planeViewController: planeViewController, firstEncounter: firstEncounter)
    }
}

class Encounter{
    
    var nextEncounter: Encounter?
    
    var waitTime: Double = 5.00
    
    var obstacles: [SCNNode]?
    var enemies: [SCNNode]?
    var letterRings: [LetterRing]?
    var numberOfFireballs: Int?
    

    init(waitTime: Double, obstacles: [SCNNode]?, enemies: [SCNNode]?, letterRings: [LetterRing]?, numberOfFireballs: Int?){
        
        self.waitTime = waitTime
        self.obstacles = obstacles
        self.enemies = enemies
        self.letterRings = letterRings
        self.numberOfFireballs = numberOfFireballs
        
        nextEncounter = nil
    }
    
    func setNextEncounter(waitTime: Double, obstacles: [SCNNode]?, enemies: [SCNNode]?, letterRings: [LetterRing]?, numberOfFireballs: Int?) -> Encounter{
        
        self.nextEncounter = Encounter(waitTime: waitTime, obstacles: obstacles, enemies: enemies, letterRings: letterRings, numberOfFireballs: numberOfFireballs)
        
        return self.nextEncounter!
    }
    
    func getNextEncounter() -> Encounter?{
        
        return nextEncounter
    }
}
