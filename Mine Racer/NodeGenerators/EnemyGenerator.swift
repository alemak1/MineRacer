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
        case SpikeBall1,SpikeBall2,SpikeBall3,SpikeBall4,SpikeBall5,SpikeBall6
        
        static let allSpikeBallTypes: [SpikeBallType] = [.SpikeBall1, .SpikeBall2,.SpikeBall3,.SpikeBall4,.SpikeBall5,.SpikeBall6]
        
        static func GetRandomSpikeBallType() -> SpikeBallType{
            
            let randomIdx = Int(arc4random_uniform(UInt32(SpikeBallType.allSpikeBallTypes.count)))
            
            return SpikeBallType.allSpikeBallTypes[randomIdx]
            
        }
    }
    
    enum SpikeTunnelType: Int{
        case ST1, ST2, ST3, ST4, ST5, ST6, ST7, ST8, ST9
    }
    
    enum SpaceCraftType: Int{
        case SpaceCraft1 = 1, SpaceCraft2, SpaceCraft3, SpaceCraft4, SpaceCraft5, SpaceCraft6
        
        static let allSpaceCraft: [SpaceCraftType] = [.SpaceCraft1, .SpaceCraft2,.SpaceCraft3,.SpaceCraft4,.SpaceCraft5,.SpaceCraft6]
        
        static func GetRandomSpaceCraftType() -> SpaceCraftType{
            
            let randomIdx = Int(arc4random_uniform(UInt32(SpaceCraftType.allSpaceCraft.count)))
            
            return SpaceCraftType.allSpaceCraft[randomIdx]
            
        }
    }
    
    enum TurretType: Int{
        case Turret1, Turret2
        
        static let allTurretTypes: [TurretType] = [.Turret1,.Turret2]
        
        static func GetRandomTurretType() -> TurretType{
            
            let randomIdx = Int(arc4random_uniform(UInt32(TurretType.allTurretTypes.count)))
            
            return TurretType.allTurretTypes[randomIdx]
            
        }
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
    var spikeBall2: SCNNode!
    var spikeBall3: SCNNode!
    var spikeBall4: SCNNode!
    var spikeBall5: SCNNode!
    var spikeBall6: SCNNode!

    
    var spikeTunnel1: SCNNode!
    var spikeTunnel2: SCNNode!
    var spikeTunnel3: SCNNode!
    var spikeTunnel4: SCNNode!
    var spikeTunnel5: SCNNode!
    var spikeTunnel6: SCNNode!
    var spikeTunnel7: SCNNode!
    var spikeTunnel8: SCNNode!
    var spikeTunnel9: SCNNode!

    
    /** Turrets **/
    
    var turret1: SCNNode!
    var turret2: SCNNode!
    
    /** Other Enemies **/
    var fireball: SCNParticleSystem!
    
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
        
        for child in originalNode.childNodes{
            let childCopy = child.copy() as! SCNNode
            spikeBallNode.addChildNode(childCopy)
        }
        
        spikeBallNode.configureWithEnemyPhysicsProperties()
        
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
        
        print("Generating moving spike ball...")
        
        let originalNode = getSpikeballNodeOf(type: type)
        
        let spikeBallNode = originalNode.copy() as! SCNNode
        
        print("The number of child nodes in the original is \(originalNode.childNodes.count)")
        print("The number of child nodes in the copy is \(spikeBallNode.childNodes.count)")
        
        for spike in originalNode.childNodes{
            print("Copying the child nodes for the spikeball")
            let spikeCopy = spike.copy() as! SCNNode
            spikeBallNode.addChildNode(spikeCopy)
        }
        
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
        
        let spaceCraft = SpaceCraft(referenceNode: spaceCraftNode, withSpawnPoint: spawnPoint, withVelocity: velocity)
        
    
        return spaceCraft
    }
    
    /** Functions for obtaining the original reference nodes **/
    
    func getSpikeTunnel(of spikeTunnelType: SpikeTunnelType) -> SCNNode{
        switch spikeTunnelType {
        case .ST1:
            return self.spikeTunnel1
        case .ST2:
            return self.spikeTunnel2
        case .ST3:
            return self.spikeTunnel3
        case .ST4:
            return self.spikeTunnel4
        case .ST5:
            return self.spikeTunnel5
        case .ST6:
            return self.spikeTunnel6
        case .ST7:
            return self.spikeTunnel7
        case .ST8:
            return self.spikeTunnel8
        case .ST9:
            return self.spikeTunnel9
    
            
        }
    }
    
    func getSpikeBallNode(of spikeBallType: SpikeBallType) -> SCNNode{
        switch spikeBallType {
            case .SpikeBall1:
                return self.spikeBall1
            case .SpikeBall2:
                return self.spikeBall2
            case .SpikeBall3:
                return self.spikeBall3
            case .SpikeBall4:
                return self.spikeBall4
            case .SpikeBall5:
                return self.spikeBall5
            case .SpikeBall6:
                return self.spikeBall6
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
    
    
    func getFireBall(withPosition position: SCNVector3 = SCNVector3(0.0, 10.0, -150), andWithVelocity velocity: SCNVector3 = SCNVector3(0.0, 0.0, 2.0)) -> SCNNode{
        
        /** Configure sphere geometry for fireball **/
        let sphereGeometry = SCNSphere(radius: 4.86)
        
        /** Configure materials for fireball surface **/
        
        let material = SCNMaterial()
        material.diffuse.contents = "art.scnassets/textures/TexturesCom_RocksArid0143_2_seamless_S.jpg"
        sphereGeometry.materials = [material]
        
        /** Create fireball node to hold particle system **/
        let fireballNode = SCNNode(geometry: sphereGeometry)
        
        let fireballCopy = self.fireball.copy() as! SCNParticleSystem
        fireballNode.addParticleSystem(fireballCopy)
        
        /** Configure physics body for fireball **/
        
        let physicsShape = SCNPhysicsShape(geometry: sphereGeometry, options: nil)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        physicsBody.friction = 0.00
        physicsBody.damping = 0.00
        physicsBody.isAffectedByGravity = false
        fireballNode.physicsBody = physicsBody
        
        fireballNode.position = position
        
        fireballNode.physicsBody?.velocity = velocity
        
        return fireballNode
        
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
        
        spikeBall2 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "SpikeBall2", recursively: true)!
        
        spikeBall3 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "SpikeBall3", recursively: true)!
        
        spikeBall4 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "SpikeBall4", recursively: true)!
        
        spikeBall5 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "SpikeBall5", recursively: true)!
        
        spikeBall6 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "SpikeBall6", recursively: true)!
        
        
        
        
        
        spikeTunnel1 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "Obstacle1", recursively: true)!
        
        spikeTunnel2 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "Obstacle2", recursively: true)!
        
        spikeTunnel3 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "Obstacle3", recursively: true)!
        
        spikeTunnel4 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "Obstacle4", recursively: true)!
        
        spikeTunnel5 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "Obstacle5", recursively: true)!
        
        spikeTunnel6 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "Obstacle6", recursively: true)!
        
        spikeTunnel7 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "Obstacle7", recursively: true)!
        
        spikeTunnel8 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "Obstacle8", recursively: true)!
        
        spikeTunnel9 = SCNScene(named: "art.scnassets/obstacles/Structures.scn")?.rootNode.childNode(withName: "Obstacle9", recursively: true)!



        /** Load turrets **/
        
        turret1 = SCNScene(named: "art.scnassets/turrets/turret_exclusive.scn")?.rootNode.childNode(withName: "turret", recursively: true)!
        
        turret2 = SCNScene(named: "art.scnassets/turrets/turretDouble_exclusive.scn")?.rootNode.childNode(withName: "turret", recursively: true)!


        /** Load other enemies **/
        
        self.fireball = SCNParticleSystem(named: "fireball", inDirectory: nil)!
    }
}


