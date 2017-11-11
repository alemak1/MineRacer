//
//  LetterRingManager.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/8/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class LetterRingManager{
    
    var ringManager = [LetterRing]()
    
    var planeViewController: PlaneViewController!
    
    init(with planeViewController: PlaneViewController) {
        self.planeViewController = planeViewController
    }
    
   
    
    func addRandomizedMovingRing(with numberOfLetterRings: Int, fromWord word: String?){
        
        for _ in 0...numberOfLetterRings{

            addRandomizedMovingRing(usingWord: word)
            
        }
        
        
    }
    
    /** Adds a moving ring with a specified letter and letter style to the plane view controller scene **/
    func addRandomizedMovingRing(usingWord word: String?){
        
        let randomLetterType = word?.getRandomLetterType() ?? LetterType.GetRandomLetterType()
        
        let newLetterRing = generateRandomizedMovingRingFor(letterType: randomLetterType, withConfiguration: LBPConfiguration.LowVelocityLargeHeightAndLargeWidthConfiguration)
        
        addLetterRing(letterRing: newLetterRing)
        
        
        
    }
    
    func generateRandomizedMovingRingGroup(numberOfRings: Int, fromWord word: String?) -> [LetterRing]{
        
        var letterRings = [LetterRing]()
        
        
        for _ in 1...numberOfRings{
            
            let randomLetterType = word?.getRandomLetterType() ?? LetterType.GetRandomLetterType()
            
            let newLetterRing = generateRandomizedMovingRingFor(letterType: randomLetterType, withConfiguration: LBPConfiguration.LowVelocityLargeHeightAndLargeWidthConfiguration)
            
            letterRings.append(newLetterRing)
        }
        
        return letterRings
    }

    
    
    func addLetterRings(letterRings: [LetterRing]){
        
        letterRings.forEach({
            letterRing in
            
            self.addLetterRing(letterRing: letterRing)
        })
    }
    
    func addLetterRing(letterRing: LetterRing){
        
        letterRing.addTo(planeViewController: planeViewController)
        
        self.ringManager.append(letterRing)
        
    }
    
    
    
 
    func generateRandomizedMovingRingFor(letterType: LetterType, withConfiguration configuration: LBPConfiguration) -> LetterRing{
        
        print("Getting randomized moving ring based on player's current position...")
        
        let (xTarget, yTarget, zTarget) = (Int(planeViewController.player.node.presentation.position.x),Int(planeViewController.player.node.presentation.position.y),Int(planeViewController.player.node.presentation.position.z))
        
        print("Getting spawn point...")
        
        let (spawnPointX,spawnPointY,spawnPointZ) = configuration.getRandomSpawnPoint()
        
        let spawnPoint = SCNVector3(xTarget + spawnPointX, yTarget + spawnPointY, zTarget + spawnPointZ)
        
        print("Getting velocity...")
        
        let velocity = configuration.getRandomVelocityVector()
        
        print("Getting letter ring node...")
        
        let movingRing = generateRingFor(letterStyle: .Blue, letterType: letterType, velocity: velocity, spawnPoint: spawnPoint)
        
        
        return movingRing
        
    }
    
    
    /** Wrapper function for the singleton letter generator **/
    
    func generateRingFor(letterStyle: LetterStyle, letterType: LetterType, velocity: SCNVector3, spawnPoint: SCNVector3) -> LetterRing{
        
        
        let movingRing = RingCreator.sharedInstance.getMovingRingFor(letterStyle: letterStyle, letterType: letterType, spawnPoint: spawnPoint, velocity: velocity)
        
        
        return movingRing
        
    }
    
    func update(with time: TimeInterval){
        
        ringManager.forEach({
            letterRing in
            
            letterRing.update(with: time)
            
            letterRing.updatePortalNodePosition()
            
            removeExcessNodes()
        })
    }
    
    func removeExcessNodes(){
        
        ringManager.forEach({
            
            letterRing in
            
            if(letterRing.ringNode.position.z > 30){
                letterRing.remove()
            }
        })
    }
    
    
}
