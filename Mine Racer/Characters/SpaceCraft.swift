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
    
    /** SpaceCraft has a main node for the spacecraft itself, and another for creating a detection area that can be used to detect enemies; An optional target node is set when the detection node contacts the player **/
    
    var detectionNode: SCNNode!
    var mainNode: SCNNode!
    
    var targetNode: SCNNode?

    /** Timing variables **/
    
    var lastUpdateTime: TimeInterval = 0.00
    var frameCount: TimeInterval = 0.00
    var shootingInterval: TimeInterval = 1.00
    
    var velocityFrameCount = 0.00
    var velocityUpdateInterval = 0.50
    
    /** Other configurable parameters **/
    
    var canFire: Bool = false
    var canUpdateVelocity: Bool = false
    
    
    init(spaceCraftType: EnemyGenerator.SpaceCraftType, spawnPoint: SCNVector3, velocity: SCNVector3){
        
        self.mainNode = EnemyGenerator.sharedInstance.getSpaceCraftNode(of: spaceCraftType)

        configureMainNodeName()
        configureSpaceCraft(withPosition: spawnPoint, withVelocity: velocity)
        configureDefaultLookAtConstraint(forSpawnPoint: spawnPoint)
        configureAuxiliaryGeometries()
        
      
    }
    

    

    func configureDefaultLookAtConstraint(forSpawnPoint spawnPoint: SCNVector3){
        let lookAtNode = SCNNode()
        lookAtNode.position = SCNVector3.init(spawnPoint.x, spawnPoint.y, 0.0)
        let lookAtConstraint = SCNLookAtConstraint(target: lookAtNode)
        self.mainNode.constraints = [lookAtConstraint]
        
    }
    
    func configureSpaceCraft(withPosition position: SCNVector3, withVelocity velocity: SCNVector3, withOpacity opacity: CGFloat = 0.00){
        
        self.mainNode.position = position
        
        self.mainNode.physicsBody?.velocity = velocity
        
        self.mainNode.opacity = opacity

        
    }
    
    func configureMainNodeName(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: Date())
        
        self.mainNode.name = "SpaceCraft\(dateString)"
        
        
    }
    
    init(referenceNode: SCNNode, withSpawnPoint spawnPoint: SCNVector3, withVelocity velocity: SCNVector3) {
        
        self.mainNode = referenceNode
        
        configureSpaceCraft(withPosition: spawnPoint, withVelocity: velocity)
        configureDefaultLookAtConstraint(forSpawnPoint: spawnPoint)
        configureAuxiliaryGeometries()
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
        
       // print("Setting the target of the spacecraft to the player....")
        
        guard let nodeName = notification?.userInfo?["nodeName"] as? String else {
            print("Error: No node name associated with the contact node for this notification")
            return
        }

        if(self.detectionNode.name != nil && nodeName != self.detectionNode.name!){
            return
        }
        

        if let planeViewController = notification?.object as? PlaneViewController{
            self.targetNode = planeViewController.player.node.presentation
            
//            let targetPos = self.targetNode!.presentation.position
//            let (x,y,z) = (CGFloat(targetPos.x),CGFloat(targetPos.y),CGFloat(targetPos.z))
//
//            self.mainNode.runAction(SCNAction.rotateTo(x: x, y: y, z: z, duration: 0.10))
//
            let constraint = SCNLookAtConstraint(target: planeViewController.player.node)
            self.mainNode.constraints = [constraint]
            
            

        }
        
        canFire = true
        canUpdateVelocity = true

        
    
        
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
    
    
    func updateVelocityToReachTarget(){
        
        if self.targetNode != nil && canUpdateVelocity{
            
            
            let targetPos = self.targetNode!.position
            let currentPos = self.mainNode.presentation.position
            
            let rawVector = currentPos.getDifference(withVector: targetPos)
            
            let adjustedVelocityVector = rawVector.multiplyByScalar(scalar: 0.01)
            
            
            self.mainNode.physicsBody?.applyForce(adjustedVelocityVector, asImpulse: true)
        }
    }
    
    func fireBulletAtTargetNode(){
        if targetNode != nil{
            fireBullet(atTarget: self.targetNode!.presentation.position, withVelocityFactor: 0.10)
        }
    }
    
   
    func fireBullet(atTarget targetPos: SCNVector3, withVelocityFactor velocityFactor: Float){
        
      
        let bulletNode = generateBullet()
    
        /** Spawn the bullet at the middle of the spacecraft **/
        
        self.mainNode.addChildNode(bulletNode)
        bulletNode.position = SCNVector3.init(0.0, 0.0, 0.0)
        
        let bulletVector = targetPos.getDifference(withVector: self.mainNode.presentation.position)
        let bulletVelocity = bulletVector.multiplyByScalar(scalar: velocityFactor)
        
        bulletNode.physicsBody?.applyForce(bulletVelocity, asImpulse: true)
        
    }
    
    func update(with time: TimeInterval){
        
        if(time == 0){
            lastUpdateTime = 0.00
        }
        
        
        frameCount += time - lastUpdateTime
        velocityFrameCount += time - lastUpdateTime
        
        if(frameCount > shootingInterval){
            //print("Shooting interval elapsed...time to shoot...checking for target node....")
            
            fireBulletAtTargetNode()
            
            frameCount = 0
        }
        
        if(velocityFrameCount > velocityUpdateInterval){
           updateVelocityToReachTarget()
            
            velocityFrameCount = 0
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
    
    
    
    /** Helper function for generating bullet nodes **/
    
    func generateBullet() -> SCNNode{
        
        /** Configure geometry and physics properties for the bullet **/

        let capsule = SCNCapsule(capRadius: 1.0, height: 5.0)
        
        capsule.materials.first?.diffuse.contents = "art.scnassets/textures/TexturesCom_AluminiumSheetMaterial_S.png"
        
        
        let bulletNode = SCNNode(geometry: capsule)
    
        /** Add constraints so that the bullet is oriented towards the player **/
        
        if(self.targetNode != nil){
            
            let targetPos = self.targetNode!.presentation.position
            
            bulletNode.runAction(SCNAction.rotateTo(x:CGFloat(targetPos.x), y: CGFloat(targetPos.y), z: CGFloat(targetPos.z), duration: 0.10))
          
            
        }
        
        
        /** Configure physics body for bullet **/

        bulletNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        bulletNode.physicsBody?.isAffectedByGravity = false
        bulletNode.physicsBody?.damping = 0.0
        bulletNode.physicsBody?.friction = 0.0
        
        bulletNode.physicsBody?.categoryBitMask = Int(CollisionMask.Bullet.rawValue)
        bulletNode.physicsBody?.collisionBitMask = Int(CollisionMask.None.rawValue)
        bulletNode.physicsBody?.contactTestBitMask = Int(CollisionMask.Player.rawValue)
        
        
        return bulletNode
    }

}
