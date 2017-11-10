//
//  FireballManager.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/10/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class FireballManager{
    
    enum FireBallType{
        case LowVelocityNHNW, HighVelocityNHNW, LowVelocityLHLW, HighVelocityLHLW
        
        static let allFireballTypes: [FireBallType]  = [.LowVelocityNHNW,.HighVelocityNHNW,.LowVelocityLHLW,.HighVelocityLHLW]
        
        static func getRandomFireballType() -> FireBallType{
            
            let totalFireballs = FireBallType.allFireballTypes.count
            let randomIdx = Int(arc4random_uniform(UInt32(totalFireballs)))
            
            //return FireBallType.allFireballTypes[randomIdx]
            
            return .HighVelocityLHLW
            
        }
    }
    
    var fireballManager = [SCNNode]()
    
    var planeViewController: PlaneViewController!
    
    init(with planeViewController: PlaneViewController) {
        self.planeViewController = planeViewController
    }
    
    /** Adds a moving ring with a specified letter and letter style to the plane view controller scene; the velocity and spawn point are randomized based on a hard-coded configuration object  **/
    
    
    func addRandomFireballs(number: Int){
        
        if(number <= 0){
            return
        }
        
        for _ in 1...number{
            let randomFireballType = FireBallType.getRandomFireballType()
            
            switch randomFireballType{
            case .HighVelocityNHNW:
                addHighVelocityNHNWFireball()
                break
            case .HighVelocityLHLW:
                addHighVelocityLHLWFireball()
                break
            case .LowVelocityLHLW:
                addLowVelocityLHLWFireball()
                break
            case .LowVelocityNHNW:
                addLowVelocityNHNWFireball()
                break
            }
        }
    }
    
    
    func addLowVelocityLHLWFireball(){
        
        let fireBall = generateLowVelocityLHLWFireball()
        
        addFireball(fireBall: fireBall)
    
        
    }
    
    func addLowVelocityNHNWFireball(){
        
        let fireBall = generateLowVelocityNHNWFireball()
        
        addFireball(fireBall: fireBall)
    }
    
    
    func addHighVelocityNHNWFireball(){
        
        let fireBall = generateHighVelocityNHNWFireball()
        
        addFireball(fireBall: fireBall)
    }
    
    func addHighVelocityLHLWFireball(){
        
        let fireBall = generateHighVelocityLHLWFireball()
        
        addFireball(fireBall: fireBall)
    }
    
    
    /** Helper functions for adding spacecraft individually and in bulk, without configuring the velocity or spawn point **/
    
    func addFireballGroup(fireballs: [SCNNode]){
        
        fireballs.forEach({
            fireball in
       
            self.addFireball(fireBall: fireball)
        })
    }
    
    func addFireball(fireBall: SCNNode){
        
       planeViewController.worldNode.addChildNode(fireBall)
        
        fireballManager.append(fireBall)
        
    }
    
    
    
    /** Generates a moving spacecraft whose spawn point and velocity are randomized based on a hard-coded default configuration object **/
    
    func generateLowVelocityLHLWFireball() -> SCNNode{
        
        return generateRandomizedFireballFor(withLBPConfiguration: LBPConfiguration.LowVelocityLargeHeightAndLargeWidthConfiguration)
    }
    
    func generateLowVelocityNHNWFireball() -> SCNNode{
        
        return generateRandomizedFireballFor(withLBPConfiguration: LBPConfiguration.LowVelocityNarrowHeightAndWidthConfiguration)
    }
    
    
    func generateHighVelocityLHLWFireball() -> SCNNode{
        return generateRandomizedFireballFor(withLBPConfiguration: LBPConfiguration.HighVelocityLargeHeightAndWidthConfiguration)

    }
    
    func generateHighVelocityNHNWFireball() -> SCNNode{
        return generateRandomizedFireballFor(withLBPConfiguration: LBPConfiguration.HighVelocityNarrowHeightAndWidthConfiguration)
    }
    
    func generateDefaultRandomizedFireball() -> SCNNode{
        
        return generateRandomizedFireballFor(withLBPConfiguration: LBPConfiguration.DefaultLBPConfiguration)
        
    }
    
    /** Generates a moving spacecraft whose spawn point is randomized based on a configuration object whose parameters are user-defined **/
    
    
    func generateRandomizedFireballFor(withLBPConfiguration configuration: LBPConfiguration) -> SCNNode{
        
        
        let (xTarget, yTarget, zTarget) = (Int(planeViewController.player.node.presentation.position.x),Int(planeViewController.player.node.presentation.position.y),Int(planeViewController.player.node.presentation.position.z))
        
        let (spawnPointX,spawnPointY,spawnPointZ) = configuration.getRandomSpawnPoint()
        
        let spawnPoint = SCNVector3(xTarget + spawnPointX, yTarget + spawnPointY, zTarget + spawnPointZ)
        
        
        let velocity = configuration.getRandomVelocityVector()
        
        
        let fireball = EnemyGenerator.sharedInstance.getFireBall()
        
        fireball.physicsBody?.velocity = velocity
        fireball.presentation.position = spawnPoint
        
        return fireball
        
    }
    
    
    func update(with time: TimeInterval){
        
        removeExcessNodes()
    }
    
    /** Remove fireballs after they pass the player **/
    
    func removeExcessNodes(){
        
        fireballManager.forEach({
            
            fireball in
            
            if(fireball.presentation.position.z > 20){
                fireball.removeFromParentNode()
            }
        })
    }
    
    
}

