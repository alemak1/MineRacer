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
    
    var didRequestRestart: Bool = false
    
    var currentEncounter: Encounter?{
        didSet{
            
            print("Current encounter has been set, executing nextencounter.....")

            if(currentEncounter != nil){
                executeEncounter()
            }
        }
    }
    
    /**
    func showEncounterSeriesInformation(){
        print("The total wait time for this encounter is: \(totalSeriesTime)")
    }
    **/
    
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
    
    @objc func activateRestartRequest(){
        print("Notification received by EncounterSeries....requesting restart")
        self.didRequestRestart = true
    }
    
    /**
    var totalSeriesTime: Double{
        return getEncounterTime()
    }

    var numberOfEncounters: Int{
        return getNumberOfEncounters(runningTotal: &nil, currentEncounter: nil)
    }
    **/

    //MARK: ******* NOT YET IMPLEMENTED
    
    /**
     func getNumberOfEncounters(runningTotal: inout Int?, currentEncounter: Encounter?) -> Int{
        

        if(runningTotal == nil){
            runningTotal = 0
        }
        
        if(currentEncounter == nil && self.firstEncounter == nil){
            
            runningTotal = 0
            
        } else if(currentEncounter == nil && self.firstEncounter != nil && self.firstEncounter.nextEncounter == nil) {
            
            runningTotal! += 1
            
        } else if(currentEncounter == nil && self.firstEncounter != nil && self.firstEncounter.nextEncounter != nil){
            
        }else if(currentEncounter != nil && self.currentEncounter?.nextEncounter == nil) {
           
            runningTotal! += 1
         
        } else if(currentEncounter != nil && self.currentEncounter?.nextEncounter != nil){
            
            runningTotal! += 1
            getNumberOfEncounters(runningTotal: &runningTotal, currentEncounter: currentEncounter!.nextEncounter!)
            
        }
        
        return runningTotal!
    }
 
 **/
    
    
    /**

    private func getEncounterTime(withEncounter encounter: Encounter? = nil) -> Double{
        
        let currentEncounter = encounter ?? self.firstEncounter
        
        var time = currentEncounter.waitTime
        
        if let nextEncounter = self.currentEncounter?.getNextEncounter(){
            
            time += getEncounterTime(withEncounter: nextEncounter)
            
        } else {
            return time
        }
        
        /** Return statement will never be executed, only provided to satisfy compiler **/
        return 0.00
    }
    **/
    
    /**
    private func getTotalLettersGenerated() -> Int{
        
        var numberOfLetters = self.firstEncounter.numberOfLetters ?? 0
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(activateRestartRequest), name: Notification.Name("didRequestRestartNotification"), object: planeViewController)
        
        
    }
    
    

    
    func start(){
        print("Starting the encounter series....setting the first encounter...")
        self.currentEncounter = self.firstEncounter
    }
    
    
    
    func executeEncounter(){
    
        if(GameHelper.sharedInstance.state != .Playing || didRequestRestart){
            return
        }
        
        if(self.currentEncounter == nil){
            return
        }
        
        let waitTime = self.currentEncounter!.waitTime
        
        print("Preparing to execute next encounter....")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + waitTime, execute: {
            
            if(GameHelper.sharedInstance.state != .Playing || self.didRequestRestart){
                return
            }
            
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
        
        
        if(GameHelper.sharedInstance.state != .Playing || self.planeViewController.scnScene.isPaused || self.planeViewController.worldNode.isPaused){
            return
        }
        
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
        
        if let numberOfTurrets = self.currentEncounter!.numberOfTurrets{
            planeViewController.turretManager.addRandomTurrets(number: numberOfTurrets)
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
        case 0...3 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 200, withMaxFireballs: level+10, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 4...7 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 150, withMaxFireballs: level+5, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0, withMaxTurrets: 0, withMaxWaitTime: 4)
        case 8...11 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 3, withNumberOfEncounters: 120, withMaxFireballs: level, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 4)
        case 12...15 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 100, withMaxFireballs: level-2, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 3)
        case 16...30 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 90, withMaxFireballs: level-5, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 3)
        case 31...10000 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 90, withMaxFireballs: level-5, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 3)

            
            /** Get encounter series for spaceship track  **/

        case 0...3 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 5, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level+9,withMaxTurrets: 0, withMaxWaitTime: 3)
        case 4...7 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 150, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level+10,withMaxTurrets: 0, withMaxWaitTime: 4)
        case 8...11 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level+5,withMaxTurrets: 0, withMaxWaitTime: 3)
        case 12...15 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxTurrets: 0, withMaxWaitTime: 2)
        case 16...30 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxTurrets: 0, withMaxWaitTime: 2)
        case 31...10000 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxTurrets: 0, withMaxWaitTime: 2)

            
            /** Get encounter series for spikeball track  **/

        case 0...3 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level+9, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 4...7 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level+5, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 8...11 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 12...15 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 16...30 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)
        case 31...10000 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxTurrets: 0, withMaxWaitTime: 5)

        
            /** Get encounter series for turret track  **/

        case 0...3 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: level+6, withMaxWaitTime: 5)
        case 4...7 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: level+5, withMaxWaitTime: 5)
        case 8...11 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: level, withMaxWaitTime: 5)
        case 12...15 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: level, withMaxWaitTime: 5)
        case 16...30 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: level, withMaxWaitTime: 5)
        case 31...10000 where levelTrack == .Turrets:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxTurrets: level, withMaxWaitTime: 5)
        default:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 3, withNumberOfEncounters: 200, withMaxFireballs: 2, withMaxSpikeBalls: 2, withMaxSpaceCraft: 2,withMaxTurrets: level, withMaxWaitTime: 5)

        }
        
    }
    
    static func GenerateEncounterSeries(forPlaneViewController planeViewController: PlaneViewController,withMaxLetter maxLetters: Int, withNumberOfEncounters numberOfEncounters: Int, withMaxFireballs maxFireballs: Int, withMaxSpikeBalls maxSpikeBalls: Int, withMaxSpaceCraft maxSpaceCraft: Int, withMaxTurrets maxTurrets: Int, withMaxWaitTime maxWaitTime: Int) -> EncounterSeries{
        
        if(numberOfEncounters < 2){
            fatalError("Error: there must be at least two encounters minimum in order for an encounter series to be generated")
        }
        
        let getMaxWaitTime = {
            
            return Double(4.00 + Double(arc4random_uniform(UInt32(maxWaitTime))))

        }
        
        
        let getRandomNumberOfSpikeBalls: ()->Int = {
            
            let maximumNum = maxSpikeBalls <= 0 ? 0: maxSpikeBalls
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
        
        let getRandomNumberOfFireballs: ()->Int = {
            
            let maximumNum = maxFireballs <= 0 ? 0: maxFireballs
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
        
        let getRandomNumberOfSpaceCraft: ()->Int = {
            
            let maximumNum = maxSpaceCraft <= 0 ? 0: maxSpaceCraft
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
        
        let getRandomNumberOfTurrets: ()->Int = {
            let maximumNum = maxTurrets <= 0 ? 0: maxTurrets
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
        
        let getRandomNumberOfLetters: ()->Int = {
            let maximumNum = maxLetters <= 0 ? 0: maxLetters
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
            
        }
       
        
        let (firstWaitTime,fireballNum1,spikeBallNum1,spaceCraftNum1,letterNum1,turretsNum1) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters(),getRandomNumberOfTurrets())
       
     
        showNumberOf(spikeballs: spikeBallNum1, spaceCraft: spaceCraftNum1, turrets: turretsNum1, fireballs: fireballNum1, letters: letterNum1, andWaitTime: firstWaitTime)
        
        let firstEncounter = Encounter(waitTime: firstWaitTime, numberOfSpikeBalls: spikeBallNum1, numberOfSpaceCraft: spaceCraftNum1, numberOfLetters: letterNum1, numberOfTurrets: turretsNum1, numberOfFireballs: fireballNum1)
        
        let (secondWaitTime,fireballNum2,spikeBallNum2,spaceCraftNum2,letterNum2,turretNum2) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters(),getRandomNumberOfTurrets())
        
        showNumberOf(spikeballs: spikeBallNum2, spaceCraft: spaceCraftNum2, turrets: turretNum2, fireballs: fireballNum2, letters: letterNum2, andWaitTime: secondWaitTime)
        
        
        var nextEncounter = firstEncounter.setNextEncounter(waitTime: secondWaitTime, numberOfSpikeBalls: spikeBallNum2, numberOfSpaceCraft: spaceCraftNum2, numberOfLetters: letterNum2, numberOfFireballs: fireballNum2, numberOfTurrets: turretNum2)
        
        for _ in 1..<numberOfEncounters-2{
            
            let (nextWaitTime,nextFireballNum,nextSpikeBallNum,nextSpaceCraftNum,nextNumberOfLetters,nextNumberOfTurrets) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters(),getRandomNumberOfTurrets())
            
            nextEncounter = nextEncounter.setNextEncounter(waitTime: nextWaitTime, numberOfSpikeBalls: nextSpikeBallNum, numberOfSpaceCraft: nextSpaceCraftNum, numberOfLetters: nextNumberOfLetters, numberOfFireballs: nextFireballNum, numberOfTurrets: nextNumberOfTurrets)
            
        }
        
        return EncounterSeries(planeViewController: planeViewController, firstEncounter: firstEncounter)
    }
    
    static func generateRandomNumberFunction(withDefaultValue defaultNum: Int, andWithMaxNumber max: Int) -> ()->Int{
        
        return {
            let maximumNum = max <= defaultNum ? defaultNum: max
        
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
    }
    
    static func showNumberOf(spikeballs: Int, spaceCraft: Int, turrets: Int, fireballs: Int, letters: Int, andWaitTime waitTime: Double){
        
        print("The generated wait time is: \(waitTime), generated spikeballs are: \(spikeballs), generated space craft are: \(spaceCraft), generated turrets are: \(turrets), generated fireballs: \(fireballs), letters: \(letters)")
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
