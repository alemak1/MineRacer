//
//  EnemyManager.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/8/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import Foundation
import SceneKit


class SpikeBallManager{
    
    var spikeBallManager = [SpikeBall]()

    var planeViewController: PlaneViewController!

    init(with planeViewController: PlaneViewController) {
        self.planeViewController = planeViewController
    }
    
    
    func addRandomizedSpikeBall(){
        
        let randomSpikeBallType = EnemyGenerator.SpikeBallType.GetRandomSpikeBallType()
        
        addRandomizedSpikeBall(withSpikeBallType: randomSpikeBallType)
    }
    
    func addRandomizedSpikeBall(withSpikeBallType spikeBallType: EnemyGenerator.SpikeBallType){
        
        let movingSpikeBall = generateRandomizedMovingSpikeBallFor(spikeBallType: spikeBallType, withLBPConfiguration: LBPConfiguration.SpikeBallDefaultConfiguration)
        
        addSpikeBall(spikeBall: movingSpikeBall)
        
        
        
    }
    
    
    /** Helper functions for adding spacecraft individually and in bulk, without configuring the velocity or spawn point **/
    
    func addSpikeBallGroup(spikeballs: [SpikeBall]){
        
        spikeBallManager.forEach({
            spikeBall in
            
            self.addSpikeBall(spikeBall: spikeBall)
        })
    }
    
    func addSpikeBall(spikeBall: SpikeBall){
        
        spikeBall.addTo(planeViewController: planeViewController)
        
        self.spikeBallManager.append(spikeBall)
        
    }
    
    
    
    /** Generates a moving spacecraft whose spawn point and velocity are randomized based on a hard-coded default configuration object **/
    
    func generateDefaultRandomizedMovingSpaceCraftFor(spikeBallType: EnemyGenerator.SpikeBallType) -> SpikeBall{
        
        return generateRandomizedMovingSpikeBallFor(spikeBallType: spikeBallType, withLBPConfiguration: LBPConfiguration.DefaultLBPConfiguration)
        
    }
    
    /** Generates a moving spacecraft whose spawn point is randomized based on a configuration object whose parameters are user-defined **/
    
    
    func generateRandomizedMovingSpikeBallFor(spikeBallType: EnemyGenerator.SpikeBallType, withLBPConfiguration configuration: LBPConfiguration) -> SpikeBall{
        
        
        let (xTarget, yTarget, zTarget) = (Int(planeViewController.player.node.presentation.position.x),Int(planeViewController.player.node.presentation.position.y),Int(planeViewController.player.node.presentation.position.z))
        
        let (spawnPointX,spawnPointY,spawnPointZ) = configuration.getRandomSpawnPoint()
        
        let spawnPoint = SCNVector3(xTarget + spawnPointX, yTarget + spawnPointY, zTarget + spawnPointZ)
        
        
        let velocity = configuration.getRandomVelocityVector()
        
        
        let movingSpikeBall = EnemyGenerator.sharedInstance.getMovingSpikeBallOf(type: spikeBallType, spawnPoint: spawnPoint, velocity: velocity)
        
        return movingSpikeBall
        
    }
    
    func removeExcessNodes(){
        
        spikeBallManager.forEach({
            
            spikeBall in
            
            if(spikeBall.mainNode.presentation.position.z > 30){
                spikeBall.remove()
            }
        })
    }

}

class SpaceCraftManager{
    
    var spaceCraftManager = [SpaceCraft]()
    
    var planeViewController: PlaneViewController!
    
    init(with planeViewController: PlaneViewController) {
        self.planeViewController = planeViewController
    }
    
    /** Adds a moving ring with a specified letter and letter style to the plane view controller scene; the velocity and spawn point are randomized based on a hard-coded configuration object  **/
    
    func addRandomizedSpaceCraft(withSpaceCraftType spaceCraftType: EnemyGenerator.SpaceCraftType){
        
        let movingSpaceCraft = generateDefaultRandomizedMovingSpaceCraftFor(spaceCraftType: spaceCraftType)
        
        addSpaceCraft(spaceCraft: movingSpaceCraft)
        
        
        
    }


    /** Helper functions for adding spacecraft individually and in bulk, without configuring the velocity or spawn point **/
    
    func addSpaceCraftGroup(spaceCraft: [SpaceCraft]){
        
        spaceCraftManager.forEach({
            spaceCraft in
            
            self.addSpaceCraft(spaceCraft: spaceCraft)
        })
    }
    
    func addSpaceCraft(spaceCraft: SpaceCraft){
        
        spaceCraft.addTo(planeViewController: planeViewController)
        
        self.spaceCraftManager.append(spaceCraft)
        
    }
    
   
    
    /** Generates a moving spacecraft whose spawn point and velocity are randomized based on a hard-coded default configuration object **/
    
    func generateDefaultRandomizedMovingSpaceCraftFor(spaceCraftType: EnemyGenerator.SpaceCraftType) -> SpaceCraft{
        
        return generateRandomizedMovingSpaceCraftFor(spaceCraftType: spaceCraftType, withLBPConfiguration: LBPConfiguration.DefaultLBPConfiguration)
        
    }
    
    /** Generates a moving spacecraft whose spawn point is randomized based on a configuration object whose parameters are user-defined **/

    
    func generateRandomizedMovingSpaceCraftFor(spaceCraftType: EnemyGenerator.SpaceCraftType, withLBPConfiguration configuration: LBPConfiguration) -> SpaceCraft{
        
        
        let (xTarget, yTarget, zTarget) = (Int(planeViewController.player.node.presentation.position.x),Int(planeViewController.player.node.presentation.position.y),Int(planeViewController.player.node.presentation.position.z))
        
        let (spawnPointX,spawnPointY,spawnPointZ) = configuration.getRandomSpawnPoint()
        
        let spawnPoint = SCNVector3(xTarget + spawnPointX, yTarget + spawnPointY, zTarget + spawnPointZ)
        
        
        let velocity = configuration.getRandomVelocityVector()
        
        
        let movingSpaceCraft = EnemyGenerator.sharedInstance.getMovingSpaceCraftOf(type: spaceCraftType, spawnPoint: spawnPoint, velocity: velocity)
        
        return movingSpaceCraft
        
    }
    
    
    func update(with time: TimeInterval){
        
        spaceCraftManager.forEach({
            
            spaceCraft in
            
            spaceCraft.update(with: time)
            
            spaceCraft.synchronizeDetectionNodePosition()
            
            removeExcessNodes()
        })
    }
    
    func removeExcessNodes(){
        
        spaceCraftManager.forEach({
            
            spaceCraft in
            
            if(spaceCraft.mainNode.presentation.position.z > 30){
                spaceCraft.remove()
            }
        })
    }
    
    
}


