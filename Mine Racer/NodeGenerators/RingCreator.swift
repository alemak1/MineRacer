//
//  RingCreator.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class RingCreator{
    
    static let sharedInstance = RingCreator()
    
    
    func getMovingRingFor(letterStyle: LetterStyle, letterType: LetterType, spawnPoint: SCNVector3, velocity: SCNVector3) -> LetterRing{
        
        print("Generating ring node...")
        
        let ring = getModifiedRingCopyFor(letterStyle: letterStyle, letterType: letterType)
        
        let letterRing = LetterRing(referenceNode: ring)
        
        print("Setting position of the ring node...")
        
        letterRing.setPosition(position: spawnPoint)
        
        print("Setting velocity for the ring...")
        
        letterRing.setVelocity(velocity: velocity)
        
        return letterRing
    }
    
    
    func getModifiedRingCopyFor(letterStyle: LetterStyle, letterType: LetterType) -> SCNNode{
        
        let letterRing = getRingFor(letterStyle: letterStyle, letterType: letterType)
        
        let letter = letterRing.copy() as! SCNNode
        

        
        
        //TODO: Reconfigure the physics properties of the letter
        let letterGeometry = letter.geometry! as! SCNTorus
        let (ringRadius, pipeRadius) = (letterGeometry.ringRadius,letterGeometry.pipeRadius)
        let geometry = SCNTorus(ringRadius: ringRadius, pipeRadius: pipeRadius)
        let shape = SCNPhysicsShape(geometry: geometry, options: nil)
        let physicsBody1 = SCNPhysicsBody(type: .dynamic, shape: shape)
        physicsBody1.isAffectedByGravity = false
        physicsBody1.allowsResting = true
        physicsBody1.damping = 0.0
        physicsBody1.friction = 0.0
        physicsBody1.collisionBitMask = Int(CollisionMask.Player.rawValue)
        physicsBody1.categoryBitMask = Int(CollisionMask.Obstacle.rawValue)
        physicsBody1.contactTestBitMask = Int(CollisionMask.Player.rawValue)
        letter.physicsBody = physicsBody1
        
        
        
        letter.rotation = SCNVector4(x: 1.0, y: 0.0, z: 0.0, w: Float.pi/2.0)

        
        return letter
    }
    
    func getRingFor(letterStyle: LetterStyle,letterType: LetterType) -> SCNNode{
        
        switch letterType {
        case .letter_A where letterStyle == .Blue:
            return blueLetterA
        case .letter_B where letterStyle == .Blue:
            return blueLetterB
        case .letter_C where letterStyle == .Blue:
            return blueLetterC
        case .letter_D where letterStyle == .Blue:
            return blueLetterD
        case .letter_E where letterStyle == .Blue:
            return blueLetterE
        case .letter_F where letterStyle == .Blue:
            return blueLetterF
        case .letter_G where letterStyle == .Blue:
            return blueLetterG
        case .letter_H where letterStyle == .Blue:
            return blueLetterH
        case .letter_I where letterStyle == .Blue:
            return blueLetterI
        case .letter_J where letterStyle == .Blue:
            return blueLetterJ
        case .letter_K where letterStyle == .Blue:
            return blueLetterK
        case .letter_L where letterStyle == .Blue:
            return blueLetterL
        case .letter_M where letterStyle == .Blue:
            return blueLetterM
        case .letter_N where letterStyle == .Blue:
            return blueLetterN
        case .letter_O where letterStyle == .Blue:
            return blueLetterO
        case .letter_P where letterStyle == .Blue:
            return blueLetterP
        case .letter_Q where letterStyle == .Blue:
            return blueLetterQ
        case .letter_R where letterStyle == .Blue:
            return blueLetterR
        case .letter_S where letterStyle == .Blue:
            return blueLetterS
        case .letter_T where letterStyle == .Blue:
            return blueLetterT
        case .letter_U where letterStyle == .Blue:
            return blueLetterU
        case .letter_V where letterStyle == .Blue:
            return blueLetterV
        case .letter_W where letterStyle == .Blue:
            return blueLetterW
        case .letter_X where letterStyle == .Blue:
            return blueLetterX
        case .letter_Y where letterStyle == .Blue:
            return blueLetterY
        case .letter_Z where letterStyle == .Blue:
            return blueLetterZ
        default:
            return blueLetterA
        }
    }
    
    /** Blue Letters **/
    
    var blueLetterA: SCNNode!
    var blueLetterB: SCNNode!
    var blueLetterC: SCNNode!
    var blueLetterD: SCNNode!
    var blueLetterE: SCNNode!
    var blueLetterF: SCNNode!
    var blueLetterG: SCNNode!
    var blueLetterH: SCNNode!
    var blueLetterI: SCNNode!
    var blueLetterJ: SCNNode!
    var blueLetterK: SCNNode!
    var blueLetterL: SCNNode!
    var blueLetterM: SCNNode!
    var blueLetterN: SCNNode!
    var blueLetterO: SCNNode!
    var blueLetterP: SCNNode!
    var blueLetterQ: SCNNode!
    var blueLetterR: SCNNode!
    var blueLetterS: SCNNode!
    var blueLetterT: SCNNode!
    var blueLetterU: SCNNode!
    var blueLetterV: SCNNode!
    var blueLetterW: SCNNode!
    var blueLetterX: SCNNode!
    var blueLetterY: SCNNode!
    var blueLetterZ: SCNNode!
    
    
    
    
    
    
    private init(){
        
        let letterRingScene = SCNScene(named: "LetterRings.scn")!
        
        //Load the blue letters
        
        blueLetterA = letterRingScene.rootNode.childNode(withName: "Blue/letter_A", recursively: true)!
        blueLetterB = letterRingScene.rootNode.childNode(withName: "Blue/letter_B", recursively: true)!
        blueLetterC = letterRingScene.rootNode.childNode(withName: "Blue/letter_C", recursively: true)!
        blueLetterD = letterRingScene.rootNode.childNode(withName: "Blue/letter_D", recursively: true)!
        blueLetterE = letterRingScene.rootNode.childNode(withName: "Blue/letter_E", recursively: true)!
        blueLetterF = letterRingScene.rootNode.childNode(withName: "Blue/letter_F", recursively: true)!
        blueLetterG = letterRingScene.rootNode.childNode(withName: "Blue/letter_G", recursively: true)!
        blueLetterH = letterRingScene.rootNode.childNode(withName: "Blue/letter_H", recursively: true)!
        blueLetterI = letterRingScene.rootNode.childNode(withName: "Blue/letter_I", recursively: true)!
        blueLetterJ = letterRingScene.rootNode.childNode(withName: "Blue/letter_J", recursively: true)!
        blueLetterK = letterRingScene.rootNode.childNode(withName: "Blue/letter_K", recursively: true)!
        blueLetterL = letterRingScene.rootNode.childNode(withName: "Blue/letter_L", recursively: true)!
        blueLetterM = letterRingScene.rootNode.childNode(withName: "Blue/letter_M", recursively: true)!
        blueLetterN = letterRingScene.rootNode.childNode(withName: "Blue/letter_N", recursively: true)!
        blueLetterO = letterRingScene.rootNode.childNode(withName: "Blue/letter_O", recursively: true)!
        blueLetterP = letterRingScene.rootNode.childNode(withName: "Blue/letter_P", recursively: true)!
        blueLetterQ = letterRingScene.rootNode.childNode(withName: "Blue/letter_Q", recursively: true)!
        blueLetterR = letterRingScene.rootNode.childNode(withName: "Blue/letter_R", recursively: true)!
        blueLetterS = letterRingScene.rootNode.childNode(withName: "Blue/letter_S", recursively: true)!
        blueLetterT = letterRingScene.rootNode.childNode(withName: "Blue/letter_T", recursively: true)!
        blueLetterU = letterRingScene.rootNode.childNode(withName: "Blue/letter_U", recursively: true)!
        blueLetterV = letterRingScene.rootNode.childNode(withName: "Blue/letter_V", recursively: true)!
        blueLetterW = letterRingScene.rootNode.childNode(withName: "Blue/letter_W", recursively: true)!
        blueLetterX = letterRingScene.rootNode.childNode(withName: "Blue/letter_X", recursively: true)!
        blueLetterY = letterRingScene.rootNode.childNode(withName: "Blue/letter_Y", recursively: true)!
        blueLetterZ = letterRingScene.rootNode.childNode(withName: "Blue/letter_Z", recursively: true)!
        
        
        
    }
    
    
}
