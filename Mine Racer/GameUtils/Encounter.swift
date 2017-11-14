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
    
        let firstEncounter = Encounter(waitTime: 3.00, numberOfSpikeBalls: nil, numberOfSpaceCraft: nil, numberOfLetters: 4, numberOfFireballs: 5)
        
        
        let secondEncounter = firstEncounter.setNextEncounter(waitTime: 4.00, numberOfSpikeBalls: 1, numberOfSpaceCraft: 0, numberOfLetters: 5, numberOfFireballs: 5)
        

        let thirdEncounter = secondEncounter.setNextEncounter(waitTime: 3.00, numberOfSpikeBalls: 0, numberOfSpaceCraft: 0, numberOfLetters: 3, numberOfFireballs: 6)
        
        
        _ = thirdEncounter.setNextEncounter(waitTime: 3.00, numberOfSpikeBalls: 0, numberOfSpaceCraft: 0, numberOfLetters: 4, numberOfFireballs: 5)
        
        return EncounterSeries(planeViewController: planeViewController, firstEncounter: firstEncounter)
    }
    
    
    static func GenerateEncounterSeries(forPlaneViewController planeViewController: PlaneViewController, forLevelTrack levelTrack: GameHelper.LevelTrack, andforLevel level: Int) -> EncounterSeries{
        
        switch level {
            
            /** Get encounter series for fireball track  **/
        case 1...3 where levelTrack == .FireBalls:
            break
        case 4...7 where levelTrack == .FireBalls:
            break
        case 8...11 where levelTrack == .FireBalls:
            break
        case 12...15 where levelTrack == .FireBalls:
            break
        case 16...30 where levelTrack == .FireBalls:
            break
        case 31...10000 where levelTrack == .FireBalls:
            break
            
            /** Get encounter series for spaceship track  **/

        case 1...3 where levelTrack == .SpaceShips:
            break
        case 4...7 where levelTrack == .SpaceShips:
            break
        case 8...11 where levelTrack == .SpaceShips:
            break
        case 12...15 where levelTrack == .SpaceShips:
            break
        case 16...30 where levelTrack == .SpaceShips:
            break
        case 31...10000 where levelTrack == .SpaceShips:
            break
            
            /** Get encounter series for spikeball track  **/

        case 1...3 where levelTrack == .SpikeBalls:
            break
        case 4...7 where levelTrack == .SpikeBalls:
            break
        case 8...11 where levelTrack == .SpikeBalls:
            break
        case 12...15 where levelTrack == .SpikeBalls:
            break
        case 16...30 where levelTrack == .SpikeBalls:
            break
        case 31...10000 where levelTrack == .SpikeBalls:
            break
        
            /** Get encounter series for turret track  **/

        case 1...3 where levelTrack == .Turrets:
            break
        case 4...7 where levelTrack == .Turrets:
            break
        case 8...11 where levelTrack == .Turrets:
            break
        case 12...15 where levelTrack == .Turrets:
            break
        case 16...30 where levelTrack == .Turrets:
            break
        case 31...10000 where levelTrack == .Turrets:
            break
        default:
            break
        }
        
        return GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 3, withNumberOfEncounters: 3, withMaxFireballs: 3, withMaxSpikeBalls: 3, withMaxSpaceCraft: 3, withMaxWaitTime: 3)
    }
    
    static func GenerateEncounterSeries(forPlaneViewController planeViewController: PlaneViewController,withMaxLetter maxLetters: Int, withNumberOfEncounters numberOfEncounters: Int, withMaxFireballs maxFireballs: Int, withMaxSpikeBalls maxSpikeBalls: Int, withMaxSpaceCraft maxSpaceCraft: Int, withMaxWaitTime maxWaitTime: Int) -> EncounterSeries{
        
        if(numberOfEncounters < 2){
            fatalError("Error: there must be at least two encounters minimum in order for an encounter series to be generated")
        }
        
        let getMaxWaitTime = {
            
            return Double(4.00 + Double(arc4random_uniform(UInt32(maxWaitTime))))

        }
        
        
        
        let getRandomNumberOfFireballs: ()->Int = {
            
            let maximumNum = maxFireballs <= 0 ? 0: maxFireballs
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
            
        }
        
        let getRandomNumberOfSpikeBalls: ()->Int = {
            
            let maximumNum = maxSpikeBalls <= 0 ? 0: maxSpikeBalls
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
            
        }
        
        let getRandomNumberOfSpaceCraft: ()->Int = {
            
            let maximumNum = maxSpaceCraft <= 0 ? 0: maxSpaceCraft
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
            
        }
        
        let getRandomNumberOfLetters: ()->Int = {
            
            let maximumNum = maxLetters <= 0 ? 0: maxLetters
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
            
        }
        
        let (firstWaitTime,fireballNum1,spikeBallNum1,spaceCraftNum1,letterNum1) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters())
       
        let firstEncounter = Encounter(waitTime: firstWaitTime, numberOfSpikeBalls: spikeBallNum1, numberOfSpaceCraft: spaceCraftNum1, numberOfLetters: letterNum1, numberOfFireballs: fireballNum1)
        
        let (secondWaitTime,fireballNum2,spikeBallNum2,spaceCraftNum2,letterNum2) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters())
        
        var nextEncounter = firstEncounter.setNextEncounter(waitTime: secondWaitTime, numberOfSpikeBalls: spikeBallNum2, numberOfSpaceCraft: spaceCraftNum2, numberOfLetters: letterNum2, numberOfFireballs: fireballNum2)
        
        for _ in 1..<numberOfEncounters-2{
            
            let (nextWaitTime,nextFireballNum,nextSpikeBallNum,nextSpaceCraftNum,nextNumberOfLetters) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters())
            
            nextEncounter = nextEncounter.setNextEncounter(waitTime: nextWaitTime, numberOfSpikeBalls: nextSpikeBallNum, numberOfSpaceCraft: nextSpaceCraftNum, numberOfLetters: nextNumberOfLetters, numberOfFireballs: nextFireballNum)
            
        }
        
        return EncounterSeries(planeViewController: planeViewController, firstEncounter: firstEncounter)
    }
}

class Encounter{
    
    var nextEncounter: Encounter?
    
    var waitTime: Double = 5.00
    
    var numberOfSpikeBalls: Int?
    var numberOfLetters: Int?
    var numberOfFireballs: Int?
    var numberOfSpaceCraft: Int?
    

    init(waitTime: Double, numberOfSpikeBalls: Int?, numberOfSpaceCraft: Int?, numberOfLetters: Int?, numberOfFireballs: Int?){
        
        self.waitTime = waitTime
        self.numberOfSpikeBalls = numberOfSpikeBalls
        self.numberOfSpaceCraft = numberOfSpaceCraft
        self.numberOfLetters = numberOfLetters
        self.numberOfFireballs = numberOfFireballs
        
        nextEncounter = nil
    }
    
    func setNextEncounter(waitTime: Double, numberOfSpikeBalls: Int?, numberOfSpaceCraft: Int?, numberOfLetters: Int?, numberOfFireballs: Int?) -> Encounter{
        
        self.nextEncounter = Encounter(waitTime: waitTime, numberOfSpikeBalls: numberOfSpikeBalls, numberOfSpaceCraft: numberOfSpaceCraft, numberOfLetters: numberOfLetters, numberOfFireballs: numberOfFireballs)
        
        return self.nextEncounter!
    }
    
    func getNextEncounter() -> Encounter?{
        
        return nextEncounter
    }
}
