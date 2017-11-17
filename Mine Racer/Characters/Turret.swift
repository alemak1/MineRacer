//
//  Turret.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/8/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit


class Turret{
    
    var turretType: EnemyGenerator.TurretType = .Turret1
    
    var detectionNode: SCNNode!
    var mainNode: SCNNode!
    var targetNode: SCNNode?
    
    
    var lastUpdateTime: TimeInterval = 0.00
    var frameCount: TimeInterval = 0.00
    var shootingInterval: TimeInterval = 0.50
    var canFire: Bool = false
    
    var ringExpansionInterval: TimeInterval = 4.00
    
    
    
    
    init(turretType: EnemyGenerator.TurretType, spawnPoint: SCNVector3, velocity: SCNVector3){
        
        self.mainNode = EnemyGenerator.sharedInstance.getTurretNodeOf(type: turretType)
        
        self.turretType = turretType
        
        self.mainNode.position = spawnPoint
        
        self.mainNode.physicsBody?.velocity = velocity
        
        self.mainNode.opacity = 0.00
        
        configureAuxiliaryGeometries()
    }
    
    init(referenceNode: SCNNode) {
        self.mainNode = referenceNode
        
        self.detectionNode = SCNNode()
        self.detectionNode.opacity = 0.00
        

        configureAuxiliaryGeometries()
    }
    
    func addTo(planeViewController: PlaneViewController){
        
        planeViewController.worldNode.addChildNode(mainNode)
        planeViewController.worldNode.addChildNode(detectionNode)
        
        //let constraint = SCNLookAtConstraint(target: planeViewController.player.node)
        //self.mainNode.constraints = [constraint]
        
       // NotificationCenter.default.addObserver(self, selector: #selector(setTarget(notification:)), name: Notification.WasDetectedBySpaceCraftNotification, object: planeViewController)
        self.targetNode = planeViewController.player.node
        let constraint = SCNLookAtConstraint(target: planeViewController.player.node)
        self.mainNode.constraints = [constraint]
        
        fadeIn()
        
    }
    
    func configureAuxiliaryGeometries(){
        
        let sphere = SCNSphere(radius: 500.0)
        self.detectionNode = SCNNode(geometry: sphere)
        self.detectionNode.configureWithDetectionNodePhysicsProperties(withName: "Turret")
    
    
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
    
    func updatePortalNodePosition(){
        self.detectionNode.position = self.mainNode.presentation.position
    }
    
    
    @objc func setTarget(notification: Notification?){
        
         print("Setting the target of the turret to the player....")
        
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
        
        canFire = true
        
        
    
    }
    
    
    func fireBulletAtTargetNode(){
        if targetNode != nil{
            let targetPos = self.targetNode!.presentation.position
            
            /** Fire two bullets **/
            
            switch self.turretType{
            case .Turret1:
                fireBullet(atTarget: targetPos, withVelocityFactor: 0.05, wtihXOffset: -5.00, withYOffset: 0.00, withZOffset: 0.00)
                fireBullet(atTarget: targetPos, withVelocityFactor: 0.05, wtihXOffset: 5.00, withYOffset: 0.00, withZOffset: 0.00)
                break
            case .Turret2:
                fireBullet(atTarget: targetPos, withVelocityFactor: 0.05, wtihXOffset: -5.00, withYOffset: 0.00, withZOffset: 0.00)
                fireBullet(atTarget: targetPos, withVelocityFactor: 0.05, wtihXOffset: 5.00, withYOffset: 0.00, withZOffset: 0.00)
                break
            }
          

        }
    }
    
    
    func fireBullet(atTarget targetPos: SCNVector3, withVelocityFactor velocityFactor: Float, wtihXOffset xOffset: Double = 0.0, withYOffset yOffset: Double = 0.0, withZOffset zOffset: Double = 0.0){
        
        
        let bulletNode = generateBullet()
        
        /** Spawn the bullet at the middle of the spacecraft **/
        
        self.mainNode.addChildNode(bulletNode)
        bulletNode.position = SCNVector3.init(0.0 + xOffset, 0.0 + yOffset, 0.0 + zOffset)
        
        let getAdjustmentFactor = { return (Int(arc4random_uniform(UInt32(40))) - 20) }
        
        let xAdj = Float(getAdjustmentFactor())
        let yAdj = Float(getAdjustmentFactor())
        let zAdj = Float(getAdjustmentFactor())
        
        var bulletVector = targetPos.getDifference(withVector: self.mainNode.position)
        bulletVector = SCNVector3.init(bulletVector.x + xAdj, bulletVector.y + yAdj, bulletVector.z + zAdj)
        let bulletVelocity = bulletVector.multiplyByScalar(scalar: velocityFactor)
        
        
        bulletNode.physicsBody?.applyForce(bulletVelocity, asImpulse: true)
        
        let removeBulletAction = SCNAction.sequence([ SCNAction.wait(duration: 0.50), SCNAction.run({_ in
            
            bulletNode.removeFromParentNode()
        })])
        
        bulletNode.runAction(removeBulletAction)
        
    }
    
    
    func update(with time: TimeInterval){
        
        if(time == 0){
            lastUpdateTime = 0.00
        }
        
     

        frameCount += time - lastUpdateTime
        
        
        if(frameCount > shootingInterval){
            //print("Shooting interval elapsed...time to shoot...checking for target node....")
            
            fireBulletAtTargetNode()
            
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
    
    
    
    /** Helper function for generating bullet nodes **/
    
    func generateBullet() -> SCNNode{
        
        /** Configure geometry and physics properties for the bullet **/
        
        let capsule = SCNCapsule(capRadius: 0.1, height: 0.5)

        capsule.materials.first?.diffuse.contents = "art.scnassets/textures/TexturesCom_AluminiumSheetMaterial_S.png"
    
        let bulletNode = SCNNode(geometry: capsule)
        
        /** Add constraints so that the bullet is oriented towards the player **/
        
        if(self.targetNode != nil){
            
            let targetPos = self.targetNode!.position
            
            bulletNode.runAction(SCNAction.rotateTo(x:CGFloat(targetPos.x), y: CGFloat(targetPos.y), z: CGFloat(targetPos.z), duration: 0.10))

        }
        
    
        /** Configure physics body for bullet **/
        
        bulletNode.configureWithBulletPhysicsProperties()
        
        return bulletNode
    }


    
}
