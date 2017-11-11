//
//  LetterRing.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/8/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit


class LetterRing{
    
    var portalNode: SCNNode!
    var ringNode: SCNNode!
    
    var lastUpdateTime: TimeInterval = 0.00
    var frameCount: TimeInterval = 0.00
    var ringExpansionInterval: TimeInterval = 4.00
    
    init(letterStyle: LetterStyle, letterType: LetterType, spawnPoint: SCNVector3, velocity: SCNVector3){
        
        self.ringNode = RingCreator.sharedInstance.getModifiedRingCopyFor(letterStyle: letterStyle, letterType: letterType)
        
        self.ringNode.presentation.position = spawnPoint
        
        self.ringNode.physicsBody?.velocity = velocity
        
        self.ringNode.opacity = 0.00

        configurePortalNode()
    }
    
    init(referenceNode: SCNNode) {
        self.ringNode = referenceNode
        
        self.ringNode.opacity = 0.00
        
        configurePortalNode()
        
    }
    
    func configurePortalNode(){
        
        /** Configure the Portal Geometry in the middle of the ring **/
        
        let geometry = SCNBox(width: 10.0, height: 10.0, length: 2.0, chamferRadius: 0.0)
        self.portalNode = SCNNode(geometry: geometry)
        self.portalNode.opacity = 0.00
        self.portalNode.position = self.ringNode.position
        portalNode.eulerAngles.z = -90
        
        let physicsShape = SCNPhysicsShape(geometry: geometry, options: nil)
        self.portalNode.physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        self.portalNode.physicsBody?.isAffectedByGravity = false
        self.portalNode.physicsBody?.categoryBitMask = Int(CollisionMask.PortalCenter.rawValue)
        self.portalNode.physicsBody?.collisionBitMask = Int(CollisionMask.None.rawValue)
        self.portalNode.physicsBody?.contactTestBitMask = Int(CollisionMask.Player.rawValue)

    }
    
    func addTo(planeViewController: PlaneViewController){
        
        planeViewController.worldNode.addChildNode(ringNode)
        planeViewController.worldNode.addChildNode(portalNode)
        
        fadeIn()

    }
    
    func remove(){
        ringNode.removeFromParentNode()
        portalNode.removeFromParentNode()
    }
    
    func setPosition(position: SCNVector3){
        
        self.ringNode.position = position
    }
    
    func setVelocity(velocity: SCNVector3){
        self.ringNode.physicsBody?.velocity = velocity
    }
    
    func fadeIn(){
        self.ringNode.runAction(SCNAction.fadeIn(duration: 2.00))

    }
    
    func updatePortalNodePosition(){
        self.portalNode.position = self.ringNode.presentation.position
    }
    
    func update(with time: TimeInterval){
        
        if(time == 0){
            lastUpdateTime = 0.00
        }
        
        
        frameCount += time - lastUpdateTime
        
        if(frameCount > ringExpansionInterval){

            let torus = ringNode.geometry! as! SCNTorus
        
            SCNTransaction.begin()
        
            SCNTransaction.animationDuration = 2.0
        
        
            SCNTransaction.completionBlock = {
            
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 2.0
            
                torus.pipeRadius = 3.00
            
                SCNTransaction.commit()
            
            }
        
            torus.pipeRadius = 6.30
        
            SCNTransaction.commit()
            
            frameCount = 0
        }
        
            lastUpdateTime = time
        }
}

