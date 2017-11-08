//
//  SpaceCraft.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/8/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class SpaceCraft{
    
    var detectionNode: SCNNode!
    var mainNode: SCNNode!
    
    var lastUpdateTime: TimeInterval = 0.00
    var frameCount: TimeInterval = 0.00
    var shootingInterval: TimeInterval = 1.00
    
    var targetNode: SCNNode?
    
    init(spaceCraftType: EnemyGenerator.SpaceCraftType, spawnPoint: SCNVector3, velocity: SCNVector3){
        
        self.mainNode = EnemyGenerator.sharedInstance.getSpaceCraftNode(of: spaceCraftType)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: Date())
        
        self.mainNode.name = "SpaceCraft\(dateString)"
        
        self.mainNode.position = spawnPoint
        
        self.mainNode.physicsBody?.velocity = velocity
        
        self.mainNode.opacity = 0.00
        
        configureAuxiliaryGeometries()
    }
    
    init(referenceNode: SCNNode) {
        self.mainNode = referenceNode
     
        
        /** Configure the Portal Geometry in the middle of the ring **/
        configureAuxiliaryGeometries()
        
    }
    
    
    
    func configureAuxiliaryGeometries(){
        
        
        let sphere = SCNSphere(radius: 500.0)
        self.detectionNode = SCNNode(geometry: sphere)
        self.detectionNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        self.detectionNode.opacity = 0.00
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: Date())
        
        self.detectionNode.name = "SpaceCraft\(dateString)"
        
        self.detectionNode.physicsBody?.categoryBitMask = Int(CollisionMask.DetectionNode.rawValue)
        self.detectionNode.physicsBody?.collisionBitMask = Int(CollisionMask.None.rawValue)
        self.detectionNode.physicsBody?.contactTestBitMask = Int(CollisionMask.Player.rawValue)

        
    }
    
  
    
    
    @objc func setTarget(notification: Notification?){
        
        print("Setting the target of the spacecraft to the player....")
        
        guard let nodeName = notification?.userInfo?["nodeName"] as? String else {
            print("Error: No node name associated with the contact node for this notification")
            return
        }

        if(self.detectionNode.name != nil && nodeName != self.detectionNode.name!){
            return
        }
        

        if let planeViewController = notification?.object as? PlaneViewController{
            self.targetNode = planeViewController.player.node.presentation
            
            let constraint = SCNLookAtConstraint(target: planeViewController.player.node)
            self.mainNode.constraints = [constraint]
            
            

        }

        
    
        
    }
    
    func addTo(planeViewController: PlaneViewController){
        
        planeViewController.worldNode.addChildNode(mainNode)
        planeViewController.worldNode.addChildNode(detectionNode)
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(setTarget(notification:)), name: Notification.WasDetectedBySpaceCraftNotification, object: planeViewController)
        

        fadeIn()
        
    }
    
    func remove(){
        mainNode.removeFromParentNode()
        detectionNode.removeFromParentNode()
    }
    
    func setPosition(position: SCNVector3){
        
        self.mainNode.position = position
    }
    
    func setVelocity(velocity: SCNVector3){
        self.mainNode.physicsBody?.velocity = velocity
    }
    
    func fadeIn(){
        self.mainNode.runAction(SCNAction.fadeIn(duration: 2.00))
        
    }
    

    func fireBullet(atTarget targetPos: SCNVector3, withVelocityFactor velocityFactor: Float){
        
        print("Firing bullet at target position: \(targetPos)")
        
        let capsule = SCNCapsule(capRadius: 5.0, height: 30.0)
        let bulletNode = SCNNode(geometry: capsule)
        
        /** Spawn the bullet at the middle of the spacecraft **/
        
        self.mainNode.addChildNode(bulletNode)
        bulletNode.position = SCNVector3.init(0.0, 0.0, 0.0)
        
    
        bulletNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        bulletNode.physicsBody?.isAffectedByGravity = false
        bulletNode.physicsBody?.damping = 0.0
        bulletNode.physicsBody?.friction = 0.0
        
        bulletNode.physicsBody?.categoryBitMask = Int(CollisionMask.Bullet.rawValue)
        bulletNode.physicsBody?.collisionBitMask = Int(CollisionMask.None.rawValue)
        bulletNode.physicsBody?.contactTestBitMask = Int(CollisionMask.Player.rawValue)
        
       
        let bulletVector = targetPos.getDifference(withVector: self.mainNode.presentation.position)
        let bulletVelocity = bulletVector.multiplyByScalar(scalar: velocityFactor)
        
        bulletNode.physicsBody?.applyForce(bulletVelocity, asImpulse: true)
        
    }
    
    func update(with time: TimeInterval){
        
        if(time == 0){
            lastUpdateTime = 0.00
        }
        
        
        frameCount += time - lastUpdateTime
        
        if(frameCount > shootingInterval){
            print("Shooting interval elapsed...time to shoot...checking for target node....")
            
            if targetNode != nil{
                fireBullet(atTarget: self.targetNode!.presentation.position, withVelocityFactor: 0.10)
            }
            
            frameCount = 0
        }
        
        lastUpdateTime = time
    }
    
    func animateExterior(){
        
        SCNTransaction.begin()
        
        SCNTransaction.animationDuration = 2.0
        
        
        SCNTransaction.completionBlock = {
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2.0
            
            
            SCNTransaction.commit()
            
        }
        
        
        SCNTransaction.commit()
    }
    
    func synchronizeDetectionNodePosition(){
        self.detectionNode.position = self.mainNode.position
    }
    
}
