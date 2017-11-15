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
    
    func showFirstEncounterInformation(){
    
            let (waitTime, fireballs,turrets,spaceCraft,spikeBalls,letters) = (
                firstEncounter.waitTime,
                firstEncounter.numberOfFireballs ?? 0,
                firstEncounter.numberOfTurrets ?? 0,
                firstEncounter.numberOfSpaceCraft ?? 0,
                firstEncounter.numberOfSpikeBalls ?? 0,
                firstEncounter.numberOfLetters ?? 0)
        
        print("The wait time for this encounter is \(waitTime) seconds, and the number of turrets is \(turrets), the number of spacecraft is \(spaceCraft), the number of spikeballs is \(spikeBalls), the number of fireballs is \(fireballs), the number of letters is \(letters)")
    }
    
    /**
    var totalSeriesTime: Double{
        return getEncounterTime()
    }
    **/
    
    //MARK: ******* NOT YET IMPLEMENTED
    
    /**
    private func getEncounterTime(withEncounter encounter: Encounter? = nil) -> Double{
        
        let currentEncounter = encounter ?? self.firstEncounter
        
        var time = currentEncounter.waitTime
        
        if let nextEncounter = self.currentEncounter?.getNextEncounter(){
            
            time += nextEncounter.waitTime
            
            return getEncounterTime(withEncounter: nextEncounter)
            
            
        } else {
            return time
        }
        
    }
    
    private func getTotalLettersGenerated() -> Int{
        
        var numberOfLetters = self.firstEncounter.numberOfLetters ?? 0.00
        
        if let nextEncounter = self.firstEncounter.getNextEncounter(){
            numberOfLetters += nextEncounter.numberOfLetters ?? 0
            
            return getTotalLettersGenerated()
        } else {
            return numberOfLetters
        }
    }
 
     **/
    
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
                self.planeViewController.encounterIsFinished = true
            }
            
        })
    }
    
    private func addGameObjects(){
        if let numberOfSpikeBalls = self.currentEncounter!.numberOfSpikeBalls{
            planeViewController.spikeBallManager.addRandomSpikeBalls(number: numberOfSpikeBalls)
        }
        
        if let numberOfSpaceCraft = self.currentEncounter!.numberOfSpaceCraft{
            planeViewController.spaceCraftManager.addRandomSpaceCraft(number: numberOfSpaceCraft)
        }
        
        if let numberOfLetters = self.currentEncounter!.numberOfLetters{
            
            planeViewController.letterRingManager.addRandomizedMovingRing(with: numberOfLetters, fromWord: planeViewController.currentWord)
        }
        
        if let numberOfFireballs = self.currentEncounter!.numberOfFireballs{
            planeViewController.fireballManager.addRandomFireballs(number: numberOfFireballs)
        }
        
    }
}


extension EncounterSeries{
    static func GetFireballSeries1(planeViewController: PlaneViewController) -> EncounterSeries{
    
        let firstEncounter = Encounter(waitTime: 3.00, numberOfSpikeBalls: nil, numberOfSpaceCraft: nil, numberOfLetters: 4, numberOfTurrets: 0, numberOfFireballs: 5)
        
        
        let secondEncounter = firstEncounter.setNextEncounter(waitTime: 4.00, numberOfSpikeBalls: 1, numberOfSpaceCraft: 0, numberOfLetters: 5, numberOfFireballs: 5, numberOfTurrets: 0)
        

        let thirdEncounter = secondEncounter.setNextEncounter(waitTime: 3.00, numberOfSpikeBalls: 0, numberOfSpaceCraft: 0, numberOfLetters: 3, numberOfFireballs: 6, numberOfTurrets: 0)
        
        
        _ = thirdEncounter.setNextEncounter(waitTime: 3.00, numberOfSpikeBalls: 0, numberOfSpaceCraft: 0, numberOfLetters: 4, numberOfFireballs: 5, numberOfTurrets: 0)
        
        return EncounterSeries(planeViewController: planeViewController, firstEncounter: firstEncounter)
    }
    
    
    static func GenerateEncounterSeries(forPlaneViewController planeViewController: PlaneViewController, forLevelTrack levelTrack: GameHelper.LevelTrack, andforLevel level: Int) -> EncounterSeries{
        
        switch level {
            
            /** Get encounter series for fireball track  **/
        case 1...3 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 5, withNumberOfEncounters: 200, withMaxFireballs: level, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 4...7 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 150, withMaxFireballs: level, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0, withMaxTurrets: 0, withMaxWaitTime: 4)
        case 8...11 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 3, withNumberOfEncounters: 120, withMaxFireballs: level, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 4)
        case 12...15 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 100, withMaxFireballs: level-2, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 3)
        case 16...30 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 90, withMaxFireballs: level-5, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 3)
        case 31...10000 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 90, withMaxFireballs: level-5, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 3)

            
            /** Get encounter series for spaceship track  **/

        case 1...3 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 5, withNumberOfEncounters: 200, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 4...7 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 150, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxTurrets: 0, withMaxWaitTime: 4)
        case 8...11 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 3, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxTurrets: 0, withMaxWaitTime: 3)
        case 12...15 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxTurrets: 0, withMaxWaitTime: 2)
        case 16...30 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxTurrets: 0, withMaxWaitTime: 2)
        case 31...10000 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxTurrets: 0, withMaxWaitTime: 2)

            
            /** Get encounter series for spikeball track  **/

        case 1...3 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 4...7 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 8...11 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 12...15 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 16...30 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 31...10000 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)

        
            /** Get encounter series for turret track  **/

        case 1...3 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 4...7 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 8...11 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 12...15 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 16...30 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 31...10000 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        default:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 3, withNumberOfEncounters: 200, withMaxFireballs: 2, withMaxSpikeBalls: 2, withMaxSpaceCraft: 2,withMaxTurrets: 0, withMaxWaitTime: 5)

        }
        
    }
    
    static func GenerateEncounterSeries(forPlaneViewController planeViewController: PlaneViewController,withMaxLetter maxLetters: Int, withNumberOfEncounters numberOfEncounters: Int, withMaxFireballs maxFireballs: Int, withMaxSpikeBalls maxSpikeBalls: Int, withMaxSpaceCraft maxSpaceCraft: Int, withMaxTurrets maxTurrets: Int, withMaxWaitTime maxWaitTime: Int) -> EncounterSeries{
        
        if(numberOfEncounters < 2){
            fatalError("Error: there must be at least two encounters minimum in order for an encounter series to be generated")
        }
        
        let getMaxWaitTime = {
            
            return Double(4.00 + Double(arc4random_uniform(UInt32(maxWaitTime))))

        }
        
        
        let (getRandomNumberOfFireballs,getRandomNumberOfSpikeBalls,getRandomNumberOfSpaceCraft,getRandomNumberOfTurrets,getRandomNumberOfLetters) = (
            EncounterSeries.generateRandomNumberFunction(withDefaultValue: 0, andWithMaxNumber: maxFireballs),
            EncounterSeries.generateRandomNumberFunction(withDefaultValue: 0, andWithMaxNumber: maxSpikeBalls),
            EncounterSeries.generateRandomNumberFunction(withDefaultValue: 0, andWithMaxNumber: maxSpaceCraft),
            EncounterSeries.generateRandomNumberFunction(withDefaultValue: 0, andWithMaxNumber: maxTurrets),
            EncounterSeries.generateRandomNumberFunction(withDefaultValue: 0, andWithMaxNumber: maxLetters)
        )
            
    
        
        let (firstWaitTime,fireballNum1,spikeBallNum1,spaceCraftNum1,letterNum1,turretsNum1) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters(),getRandomNumberOfTurrets())
       
        let firstEncounter = Encounter(waitTime: firstWaitTime, numberOfSpikeBalls: spikeBallNum1, numberOfSpaceCraft: spaceCraftNum1, numberOfLetters: letterNum1, numberOfTurrets: turretsNum1, numberOfFireballs: fireballNum1)
        
        let (secondWaitTime,fireballNum2,spikeBallNum2,spaceCraftNum2,letterNum2,turretNum2) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters(),getRandomNumberOfTurrets())
        
        var nextEncounter = firstEncounter.setNextEncounter(waitTime: secondWaitTime, numberOfSpikeBalls: spikeBallNum2, numberOfSpaceCraft: spaceCraftNum2, numberOfLetters: letterNum2, numberOfFireballs: fireballNum2, numberOfTurrets: turretNum2)
        
        for _ in 1..<numberOfEncounters-2{
            
            let (nextWaitTime,nextFireballNum,nextSpikeBallNum,nextSpaceCraftNum,nextNumberOfLetters,nextNumberOfTurrets) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters(),getRandomNumberOfTurrets())
            
            nextEncounter = nextEncounter.setNextEncounter(waitTime: nextWaitTime, numberOfSpikeBalls: nextSpikeBallNum, numberOfSpaceCraft: nextSpaceCraftNum, numberOfLetters: nextNumberOfLetters, numberOfFireballs: nextFireballNum, numberOfTurrets: nextNumberOfTurrets)
            
        }
        
        return EncounterSeries(planeViewController: planeViewController, firstEncounter: firstEncounter)
    }
    
    static func generateRandomNumberFunction(withDefaultValue defaultNum: Int, andWithMaxNumber max: Int) -> ()->Int{
        
        return {
            let maximumNum = defaultNum <= 0 ? 0: max
        
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
    }
}

class Encounter{
    
    var nextEncounter: Encounter?
    
    var waitTime: Double = 5.00
    
    var numberOfSpikeBalls: Int?
    var numberOfLetters: Int?
    var numberOfFireballs: Int?
    var numberOfSpaceCraft: Int?
    var numberOfTurrets: Int?
    

    init(waitTime: Double, numberOfSpikeBalls: Int?, numberOfSpaceCraft: Int?, numberOfLetters: Int?,numberOfTurrets: Int?, numberOfFireballs: Int?){
        
        self.waitTime = waitTime
        self.numberOfSpikeBalls = numberOfSpikeBalls
        self.numberOfSpaceCraft = numberOfSpaceCraft
        self.numberOfLetters = numberOfLetters
        self.numberOfFireballs = numberOfFireballs
        self.numberOfTurrets = numberOfTurrets
        
        nextEncounter = nil
    }
    
    func setNextEncounter(waitTime: Double, numberOfSpikeBalls: Int?, numberOfSpaceCraft: Int?, numberOfLetters: Int?, numberOfFireballs: Int?, numberOfTurrets: Int?) -> Encounter{
        
        self.nextEncounter = Encounter(waitTime: waitTime, numberOfSpikeBalls: numberOfSpikeBalls, numberOfSpaceCraft: numberOfSpaceCraft, numberOfLetters: numberOfLetters, numberOfTurrets: numberOfTurrets, numberOfFireballs: numberOfFireballs)
        
        return self.nextEncounter!
    }
    
    func getNextEncounter() -> Encounter?{
        
        return nextEncounter
    }
}
