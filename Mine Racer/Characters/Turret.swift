//
//  Turret.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/8/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit


class AlienHeadNode{
    
    var alienHead: EnemyGenerator.AlienHead = .PinkAlien
    
    var detectionNode: SCNNode!
    var mainNode: SCNNode!
    var targetNode: SCNNode?
    
    
    var lastUpdateTime: TimeInterval = 0.00
    var frameCount: TimeInterval = 0.00
    var shootingInterval: TimeInterval = 0.50
    var canFire: Bool = false
    
    var ringExpansionInterval: TimeInterval = 4.00
    
    
    
    
    init(alienHead: EnemyGenerator.AlienHead, spawnPoint: SCNVector3, velocity: SCNVector3){
        
        self.mainNode = EnemyGenerator.sharedInstance.getAlienHead(of: alienHead)
        
        self.alienHead = alienHead
        
        self.mainNode.configureWithEnemyPhysicsProperties()
        
        self.mainNode.position = spawnPoint
        
        self.mainNode.physicsBody?.velocity = velocity
        
        self.mainNode.opacity = 0.00
        
        configureAuxiliaryGeometries()
    }
    
    init(referenceNode: SCNNode) {
        self.mainNode = referenceNode
        
        self.mainNode.configureWithEnemyPhysicsProperties()
        
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
    
    
    func attackTargetNode(){
        if targetNode != nil{
            let targetPos = self.targetNode!.presentation.position
            
   

        }
    }
    
   
    
    
    func update(with time: TimeInterval){
        
        if(time == 0){
            lastUpdateTime = 0.00
        }
        
     

        frameCount += time - lastUpdateTime
        
        
        if(frameCount > shootingInterval){
            //print("Shooting interval elapsed...time to shoot...checking for target node....")
            
            
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
