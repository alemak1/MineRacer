//
//  EnemyGenerator.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class EnemyGenerator{
    
    
    
    enum SpikeBallType: Int{
        case SpikeBall1
    }
    
    enum SpikeTunnelType: Int{
        case ST1, ST2, ST3, ST4, ST5, ST6, ST7, ST8, ST9
    }
    
    enum SpaceCraftType: Int{
        case SpaceCraft1 = 1, SpaceCraft2, SpaceCraft3, SpaceCraft4, SpaceCraft5, SpaceCraft6
    }
    
    enum TurretType: Int{
        case Turret1, Turret2
    }
    
    static let sharedInstance = EnemyGenerator()
    
    /** Enemy SpaceCraft **/
    var spaceCraft1: SCNNode!
    var spaceCraft2: SCNNode!
    var spaceCraft3: SCNNode!
    var spaceCraft4: SCNNode!
    var spaceCraft5: SCNNode!
    var spaceCraft6: SCNNode!

    /** Deadly Obstacles **/
    
    var spikeBall1: SCNNode!
    var spikeTunnel1: SCNNode!
    
    /** Turrets **/
    
    var turret1: SCNNode!
    var turret2: SCNNode!
    
    /** Functions for generating copies of the reference node **/
    

    
    func getSpikeTunnelNodeOf(type: SpikeTunnelType) -> SCNNode{
        
        print("Generating ring node...")
        
        let originalNode = getSpikeTunnel(of: type)
        
        let spikeTunnel = originalNode.copy() as! SCNNode
        
        return spikeTunnel
    }
    
    func getSpikeballNodeOf(type: SpikeBallType) -> SCNNode{
        
        print("Generating ring node...")
        
        let originalNode = getSpikeBallNode(of: type)
        
        let spikeBallNode = originalNode.copy() as! SCNNode
        
        return spikeBallNode
    }
    
    func getSpaceCraftNodeOf(type: SpaceCraftType) -> SCNNode{
        
        print("Generating ring node...")
        
        let originalNode = getSpaceCraftNode(of: type)
        
        let spaceCraftNode = originalNode.copy() as! SCNNode
        
        return spaceCraftNode
    }
    
    func getTurretNodeOf(type: TurretType) -> SCNNode{
        
        let originalNode = getTurretNode(of: type)
        
        let turretNode = originalNode.copy() as! SCNNode
        
        return turretNode
    }
    
    /** Convenience Functions for Generating Copies of the reference node with predefined velocity and position **/
    
    
   // func getMovingSpikeTunnelOf(type: SpikeTunnelType, spawnPoint: SCNVector3, velocity: SCNVector3)
    
    func getMovingSpikeCorridorOf(type: SpikeTunnelType, spawnPoint: SCNVector3, velocity: SCNVector3) -> SpikeCorridor{
        
        let originalNode = getSpikeTunnelNodeOf(type: type)
        
        let spikeTunnelNode = originalNode.copy() as! SCNNode
        
        let spikeTunnel = SpikeCorridor(referenceNode: spikeTunnelNode)
        
        spikeTunnel.setPosition(position: spawnPoint)
        spikeTunnel.setVelocity(velocity: velocity)
        
        return spikeTunnel
        
    }
    
    func getMovingSpikeBallOf(type: SpikeBallType, spawnPoint: SCNVector3, velocity: SCNVector3) -> SpikeBall{
        
        let originalNode = getSpikeballNodeOf(type: type)
        
        let spikeBallNode = originalNode.copy() as! SCNNode
        
        let spikeBall = SpikeBall(referenceNode: spikeBallNode)
        
        spikeBall.setPosition(position: spawnPoint)
        spikeBall.setVelocity(velocity: velocity)
        
        return spikeBall
        
    }
    
    func getMovingTurretOf(type: TurretType, spawnPoint: SCNVector3, velocity: SCNVector3) -> Turret{
        
        
        
        let originalNode = getTurretNodeOf(type: type)
        
        let turretNode = originalNode.copy() as! SCNNode
        
        let turret = Turret(referenceNode: turretNode)
        
        turret.setPosition(position: spawnPoint)
        turret.setVelocity(velocity: velocity)
        
        return turret
        
    }
    
    func getMovingSpaceCraftOf(type: SpaceCraftType, spawnPoint: SCNVector3, velocity: SCNVector3) -> SpaceCraft{
        
        
        let originalNode = getSpaceCraftNode(of: type)
        
        let spaceCraftNode = originalNode.copy() as! SCNNode
        
        let spaceCraft = SpaceCraft(referenceNode: spaceCraftNode)
        
        
        spaceCraft.setPosition(position: spawnPoint)
        spaceCraft.setVelocity(velocity: velocity)
        
        return spaceCraft
    }
    
    /** Functions for obtaining the original reference nodes **/
    
    func getSpikeTunnel(of spikeTunnelType: SpikeTunnelType) -> SCNNode{
        switch spikeTunnelType {
        case .ST1:
            return self.spikeTunnel1
        default:
            return self.spikeTunnel1
            
        }
    }
    
    func getSpikeBallNode(of spikeBallType: SpikeBallType) -> SCNNode{
        switch spikeBallType {
        case .SpikeBall1:
            return self.spikeBall1
            
        }
    }
    
    func getTurretNode(of turretType: TurretType) -> SCNNode{
        switch turretType {
        case .Turret1:
            return self.turret1
        case .Turret2:
            return self.turret2
            
        }
    }
    
    func getSpaceCraftNode(of spaceCraftType: SpaceCraftType) -> SCNNode{
        
        switch spaceCraftType {
            case .SpaceCraft1:
                return self.spaceCraft1
            case .SpaceCraft2:
                return self.spaceCraft2
            case .SpaceCraft3:
                return self.spaceCraft3
            case .SpaceCraft4:
                return self.spaceCraft4
            case .SpaceCraft5:
                return self.spaceCraft5
            case .SpaceCraft6:
                return self.spaceCraft6
        }
    }

    private init(){
        
        /** Load enemy spacecraft **/
        
        spaceCraft1 = SCNScene(named: "art.scnassets/spacecraft/spaceCraft1.scn")?.rootNode.childNode(withName: "spaceCraft1", recursively: true)!
        spaceCraft2 = SCNScene(named: "art.scnassets/spacecraft/spaceCraft2.scn")?.rootNode.childNode(withName: "spaceCraft2", recursively: true)!
        spaceCraft3 = SCNScene(named: "art.scnassets/spacecraft/spaceCraft3.scn")?.rootNode.childNode(withName: "spaceCraft3", recursively: true)!
        spaceCraft4 = SCNScene(named: "art.scnassets/spacecraft/spaceCraft4.scn")?.rootNode.childNode(withName: "spaceCraft4", recursively: true)!
       spaceCraft5 = SCNScene(named: "art.scnassets/spacecraft/spaceCraft5.scn")?.rootNode.childNode(withName: "spaceCraft5", recursively: true)!
        spaceCraft6 = SCNScene(named: "art.scnassets/spacecraft/spaceCraft6.scn")?.rootNode.childNode(withName: "spaceCraft6", recursively: true)!

        
        /** Load obstacles (e.g. spike tunnels, spike balls, etc. )**/
        spikeBall1 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "SpikeBall1", recursively: true)!
        spikeTunnel1 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "Obstacle1", recursively: true)!

        /** Load turrets **/
        
        turret1 = SCNScene(named: "art.scnassets/turrets/turret_exclusive.scn")?.rootNode.childNode(withName: "turret", recursively: true)!
        
        turret2 = SCNScene(named: "art.scnassets/turrets/turretDouble_exclusive.scn")?.rootNode.childNode(withName: "turret", recursively: true)!


    }
}


