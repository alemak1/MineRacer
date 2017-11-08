//
//  EnemyManager.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/8/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import Foundation
import SceneKit

class SpaceCraftManager{
    
    var spaceCraftManager = [SpaceCraft]()
    
    var planeViewController: PlaneViewController!
    
    init(with planeViewController: PlaneViewController) {
        self.planeViewController = planeViewController
    }
    
    
    
    /** Adds a moving ring with a specified letter and letter style to the plane view controller scene **/
    func addRandomizedSpaceCraft(withSpaceCraftType spaceCraftType: EnemyGenerator.SpaceCraftType){
        
        let movingSpaceCraft = generateRandomizedMovingSpaceCraftFor(spaceCraftType: spaceCraftType)
        
        movingSpaceCraft.addTo(planeViewController: planeViewController)
        
        self.spaceCraftManager.append(movingSpaceCraft)
        
        
    }
    
    
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
    
    
    func generateRandomizedMovingSpaceCraftFor(spaceCraftType: EnemyGenerator.SpaceCraftType) -> SpaceCraft{
        
        print("Getting randomized moving ring based on player's current position...")
        
        let (xTarget, yTarget, zTarget) = (Int(planeViewController.player.node.presentation.position.x),Int(planeViewController.player.node.presentation.position.y),Int(planeViewController.player.node.presentation.position.z))
        
        print("Getting spawn point...")
        
        let (spawnPointX,spawnPointY,spawnPointZ) = LBPConfiguration.DefaultLBPConfiguration.getRandomSpawnPoint()
        
        let spawnPoint = SCNVector3(xTarget + spawnPointX, yTarget + spawnPointY, zTarget + spawnPointZ)
        
        print("Getting velocity...")
        
        let velocity = SCNVector3(0.0, 0.0,3.0)
        
        print("Getting letter ring node...")
        
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

