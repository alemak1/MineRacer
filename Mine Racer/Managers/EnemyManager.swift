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
    
    func addRandomSpikeBalls(number: Int){
        
        if(number <= 0){
            return
        }
        
        for _ in 1...number{
            let randomVelocityType = VelocityType.getDefaultVelocityType()
            
            switch randomVelocityType{
            case .HighVelocityNHNW:
                addHighVelocityNHNWSpikeBall()
                break
            case .HighVelocityLHLW:
                addHighVelocityLHLWSpikeBall()
                break
            case .LowVelocityLHLW:
                addLowVelocityLHLWSpikeBall()
                break
            case .LowVelocityNHNW:
                addLowVelocityNHNWSpikeBall()
                break
            }
        }
    }
    
    func addHighVelocityNHNWSpikeBall(){
        
        addRandomizedSpikeBall(withConfigurationType: LBPConfiguration.HighVelocityNarrowHeightAndWidthConfiguration)

    }

    func addHighVelocityLHLWSpikeBall(){
        
        addRandomizedSpikeBall(withConfigurationType: LBPConfiguration.HighVelocityLargeHeightAndWidthConfiguration)

    }

    func addLowVelocityLHLWSpikeBall(){
        
        addRandomizedSpikeBall(withConfigurationType: LBPConfiguration.LowVelocityLargeHeightAndLargeWidthConfiguration)

    }

    
    func addLowVelocityNHNWSpikeBall(){
        
        addRandomizedSpikeBall(withConfigurationType: LBPConfiguration.LowVelocityNarrowHeightAndWidthConfiguration)
    }
    
    func addRandomizedSpikeBall(withConfigurationType configuration: LBPConfiguration){
        
        let randomSpikeBallType = EnemyGenerator.SpikeBallType.GetRandomSpikeBallType()
        
        let movingSpikeBall = generateRandomizedMovingSpikeBallFor(spikeBallType: randomSpikeBallType, withLBPConfiguration: configuration)

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
    
    func generateLowVelocityLGLWSpikeball(forSpikeBallType spikeBallType: EnemyGenerator.SpikeBallType) -> SpikeBall{
        
        return generateRandomizedMovingSpikeBallFor(spikeBallType: spikeBallType, withLBPConfiguration: LBPConfiguration.LowVelocityLargeHeightAndLargeWidthConfiguration)
    }
    
    
    
    func generateLowVelocityNHNWSpikeball(forSpikeBallType spikeBallType: EnemyGenerator.SpikeBallType) -> SpikeBall{
        
        return generateRandomizedMovingSpikeBallFor(spikeBallType: spikeBallType, withLBPConfiguration: LBPConfiguration.LowVelocityNarrowHeightAndWidthConfiguration)
    }
    
    
    func generateHighVelocityNHNWSpikeball(forSpikeBallType spikeBallType: EnemyGenerator.SpikeBallType) -> SpikeBall{
        
        return generateRandomizedMovingSpikeBallFor(spikeBallType: spikeBallType, withLBPConfiguration: LBPConfiguration.HighVelocityNarrowHeightAndWidthConfiguration)
    }
    
    func generateHighVelocityLGLWSpikeBall(forSpikeBallType spikeBallType: EnemyGenerator.SpikeBallType) -> SpikeBall{
        
        return generateRandomizedMovingSpikeBallFor(spikeBallType: spikeBallType, withLBPConfiguration: LBPConfiguration.HighVelocityLargeHeightAndWidthConfiguration)

    }
    
    func generateDefaultRandomizedMovingSpikeBallFor(spikeBallType: EnemyGenerator.SpikeBallType) -> SpikeBall{
        
        return generateRandomizedMovingSpikeBallFor(spikeBallType: spikeBallType, withLBPConfiguration: LBPConfiguration.DefaultLBPConfiguration)
        
    }
    
    /** Generates a moving spacecraft whose spawn point is randomized based on a configuration object whose parameters are user-defined **/
    
    
    func generateRandomizedMovingSpikeBallFor(spikeBallType: EnemyGenerator.SpikeBallType, withLBPConfiguration configuration: LBPConfiguration) -> SpikeBall{
        
        
        let (xTarget, yTarget, zTarget) = (Int(planeViewController.player.node.presentation.position.x),Int(planeViewController.player.node.presentation.position.y),Int(planeViewController.player.node.presentation.position.z))
        
        let (spawnPointX,spawnPointY,spawnPointZ) = configuration.getRandomSpawnPoint()
        
        let spawnPoint = SCNVector3(xTarget + spawnPointX, yTarget + spawnPointY, zTarget + spawnPointZ)
        
        
        let velocity = configuration.getRandomVelocityVector()
        
        return  SpikeBall(spikeBallType: spikeBallType, spawnPoint: spawnPoint, velocity: velocity)
       // let movingSpikeBall = EnemyGenerator.sharedInstance.getMovingSpikeBallOf(type: spikeBallType, spawnPoint: spawnPoint, velocity: velocity)
        
       // return movingSpikeBall
        
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
    
    
    
    func addRandomSpaceCraft(number: Int){
        
        if(number <= 0){
            return
        }
        
        for _ in 1...number{
            addRandomizedSpaceCraft()
        }
    }
    

    func addRandomizedSpaceCraft(){
        let randomSpaceCraftType = EnemyGenerator.SpaceCraftType.GetRandomSpaceCraftType()
        let randomVelocityType = VelocityType.getDefaultVelocityType()
        
        var spaceCraft: SpaceCraft!
        
        switch randomVelocityType {
        case .HighVelocityLHLW:
            spaceCraft = generateHighVelocityLHLWRandomSpaceCraftFor(spaceCraftType: randomSpaceCraftType)
            break
        case .HighVelocityNHNW:
            spaceCraft = generateHighVelocityNHNWRandomSpaceCraftFor(spaceCraftType: randomSpaceCraftType)
            break
        case .LowVelocityLHLW:
            spaceCraft = generateLowVelocityLHLWRandomSpaceCraftFor(spaceCraftType: randomSpaceCraftType)
            break
        case .LowVelocityNHNW:
            spaceCraft = generateLowVelocityNHNWRandomSpaceCraftFor(spaceCraftType: randomSpaceCraftType)

            break
        }
        
        
        
        addSpaceCraft(spaceCraft: spaceCraft)
        
    }


    /** Helper functions for adding spacecraft individually and in bulk, without configuring the velocity or spawn point **/
    
    func addSpaceCraftGroup(spaceCraft: [SpaceCraft]){
        
        spaceCraft.forEach({
            spaceCraft in
            
            self.addSpaceCraft(spaceCraft: spaceCraft)
        })
    }
    
    func addSpaceCraft(spaceCraft: SpaceCraft){
        
        spaceCraft.addTo(planeViewController: planeViewController)
        
        self.spaceCraftManager.append(spaceCraft)
        
    }
    
   
    
    
    /** Generates a moving spacecraft whose spawn point and velocity are randomized based on a hard-coded default configuration object **/
    
    
    func generateLowVelocityNHNWRandomSpaceCraftFor(spaceCraftType: EnemyGenerator.SpaceCraftType) -> SpaceCraft{
        
        return generateRandomizedMovingSpaceCraftFor(spaceCraftType: spaceCraftType, withLBPConfiguration: LBPConfiguration.LowVelocityNarrowHeightAndWidthConfiguration)
        
    }

    func generateLowVelocityLHLWRandomSpaceCraftFor(spaceCraftType: EnemyGenerator.SpaceCraftType) -> SpaceCraft{
        
        return generateRandomizedMovingSpaceCraftFor(spaceCraftType: spaceCraftType, withLBPConfiguration: LBPConfiguration.LowVelocityLargeHeightAndLargeWidthConfiguration)
        
    }
    
    
    func generateHighVelocityNHNWRandomSpaceCraftFor(spaceCraftType: EnemyGenerator.SpaceCraftType) -> SpaceCraft{
        
        return generateRandomizedMovingSpaceCraftFor(spaceCraftType: spaceCraftType, withLBPConfiguration: LBPConfiguration.HighVelocityNarrowHeightAndWidthConfiguration)
        
    }
    
    func generateHighVelocityLHLWRandomSpaceCraftFor(spaceCraftType: EnemyGenerator.SpaceCraftType) -> SpaceCraft{
        
        return generateRandomizedMovingSpaceCraftFor(spaceCraftType: spaceCraftType, withLBPConfiguration: LBPConfiguration.HighVelocityLargeHeightAndWidthConfiguration)
        
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
            
            if(spaceCraft.mainNode.presentation.position.z > 0){
                spaceCraft.remove()
            }
        })
    }
    
    
}



class AlienHeadManager{
    
    var alienHeadManager = [AlienHeadNode]()
    
    var planeViewController: PlaneViewController!
    
    init(with planeViewController: PlaneViewController) {
        self.planeViewController = planeViewController
    }
    
    /** Adds a moving ring with a specified letter and letter style to the plane view controller scene; the velocity and spawn point are randomized based on a hard-coded configuration object  **/
    

    
    
    func addRandomAlienHeads(number: Int){
        
        if(number <= 0){
            return
        }
        
        for _ in 1...number{
            addRandomizedAlienHead()
        }
    }
    
    
    func addRandomizedAlienHead(){
        let randomAlienHead = EnemyGenerator.AlienHead.GetRandomAlienHead()
        
        let randomVelocityType = VelocityType.getDefaultVelocityType()
        
        var alienHeadNode: AlienHeadNode!
        
        switch randomVelocityType {
        case .HighVelocityLHLW:
            alienHeadNode = generateHighVelocityLHLWRandomAlienHeadFor(alienHead: randomAlienHead)
            break
        case .HighVelocityNHNW:
            alienHeadNode = generateHighVelocityNHNWRandomAlienHeadFor(alienHead: randomAlienHead)
            break
        case .LowVelocityLHLW:
            alienHeadNode = generateLowVelocityLHLWRandomAlienHeadFor(alienHead: randomAlienHead)
            break
        case .LowVelocityNHNW:
            alienHeadNode = generateLowVelocityNHNWRandomAlienHeadFor(alienHead: randomAlienHead)
            break
        }
        
        addAlienHeadNode(alienHeadNode: alienHeadNode)
        
        
    }
    
    
    /** Helper functions for adding spacecraft individually and in bulk, without configuring the velocity or spawn point **/
  
    
    func addAlienHeadNode(alienHeadNode: AlienHeadNode){
        
        alienHeadNode.addTo(planeViewController: planeViewController)
        
        self.alienHeadManager.append(alienHeadNode)
        
    }
    
    
    
    
    /** Generates a moving spacecraft whose spawn point and velocity are randomized based on a hard-coded default configuration object **/
    
    
    func generateLowVelocityNHNWRandomAlienHeadFor(alienHead: EnemyGenerator.AlienHead) -> AlienHeadNode{
        
        return generateRandomizedMovingAlienHeadFor(alienHead: alienHead, withLBPConfiguration: LBPConfiguration.HighVelocityNarrowHeightAndWidthConfiguration)
        
    }
    
    func generateLowVelocityLHLWRandomAlienHeadFor(alienHead: EnemyGenerator.AlienHead) -> AlienHeadNode{
        
        return generateRandomizedMovingAlienHeadFor(alienHead: alienHead, withLBPConfiguration: LBPConfiguration.LowVelocityLargeHeightAndLargeWidthConfiguration)
        
    }
    
    
    func generateHighVelocityNHNWRandomAlienHeadFor(alienHead: EnemyGenerator.AlienHead) -> AlienHeadNode{
        
        return generateRandomizedMovingAlienHeadFor(alienHead: alienHead, withLBPConfiguration: LBPConfiguration.HighVelocityNarrowHeightAndWidthConfiguration)
        
    }
    
    func generateHighVelocityLHLWRandomAlienHeadFor(alienHead: EnemyGenerator.AlienHead) -> AlienHeadNode{
        
        return generateRandomizedMovingAlienHeadFor(alienHead: alienHead, withLBPConfiguration: LBPConfiguration.HighVelocityLargeHeightAndWidthConfiguration)
        
    }
    
    /** Generates a moving spacecraft whose spawn point is randomized based on a configuration object whose parameters are user-defined **/
    
    
    func generateRandomizedMovingAlienHeadFor(alienHead: EnemyGenerator.AlienHead, withLBPConfiguration configuration: LBPConfiguration) -> AlienHeadNode{
        
        
        let (xTarget, yTarget, zTarget) = (Int(planeViewController.player.node.presentation.position.x),Int(planeViewController.player.node.presentation.position.y),Int(planeViewController.player.node.presentation.position.z))
        
        let (spawnPointX,spawnPointY,spawnPointZ) = configuration.getRandomSpawnPoint()
        
        let spawnPoint = SCNVector3(xTarget + spawnPointX, yTarget + spawnPointY, zTarget + spawnPointZ)
        
        
        let velocity = configuration.getRandomVelocityVector()
        
        
        let movingTurret = EnemyGenerator.sharedInstance.getMovingAlienHeadOf(type: alienHead, spawnPoint: spawnPoint, velocity: velocity)
        
        return movingTurret
        
    }
    
    
    func update(with time: TimeInterval){
        
        alienHeadManager.forEach({
            
            alienHead in
            
            alienHead.update(with: time)
            
            alienHead.synchronizeDetectionNodePosition()
            
            removeExcessNodes()
        })
    }
    
    func removeExcessNodes(){
        
        alienHeadManager.forEach({
            
            alienHead in
            
            if(alienHead.mainNode.presentation.position.z > 0){
                alienHead.remove()
            }
        })
    }
    
    
}



