//
//  Plane.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class Plane{
    
    var node: SCNNode!
    
    
    //MARK: ********** Character Properties
    
    var health: Int = 6
    
    func takeDamage(by damageAmount: Int){
        health -= damageAmount
    }
   
    //MARK: ************* Parameters for Configuring Character Actions
    
    var rollDuration = 0.70
    var pitchDuration = 0.70
    var moveDuration = 0.70
    var restoreDuration = 0.20
    var movementDistance: CGFloat = 15.00
    
    var forwardMovementDistance: CGFloat{
            return forwardSpeed*CGFloat(forwardMovementDuration)
    }
    
    var forwardMovementDuration: TimeInterval = 1.00
    
    var forwardSpeed: CGFloat = 0.01
    
    //MARK: ************* Initializers
    
    init(withReferenceNode referenceNode: SCNNode) {
        node = referenceNode
        node.name = "player"
    
        node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        node.presentation.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        node.physicsBody?.categoryBitMask = Int(CollisionMask.Player.rawValue)
        node.physicsBody?.isAffectedByGravity = false
        node.physicsBody!.allowsResting = false
        node.physicsBody?.damping = 0.00
        node.physicsBody?.friction = 0.00
        
        node.physicsBody?.categoryBitMask = Int(CollisionMask.Player.rawValue)
        node.physicsBody?.collisionBitMask = Int(CollisionMask.Obstacle.rawValue | CollisionMask.Barrier.rawValue)
        node.physicsBody?.contactTestBitMask = Int(CollisionMask.PortalCenter.rawValue | CollisionMask.DetectionNode.rawValue)
    }
    
    //MARK:  *********** Configure Character Actions
    
    lazy var moveForwardAction: SCNAction = {
        
        let action = SCNAction.moveBy(x: 0.00, y: 0.00, z: self.forwardMovementDistance, duration: self.forwardMovementDuration)
        
        action.timingMode = .linear
        
        return action
        
    }()
    
    lazy var rollLeftAction: SCNAction = {
        
        let action = SCNAction.rotateTo(x: 0.0, y: 0.0, z: CGFloat.pi/4.0, duration: self.rollDuration, usesShortestUnitArc: true)
        
        action.timingMode = .easeOut
        
        return action
    }()
    
    

    
    lazy var rollRightAction: SCNAction = {
        
        let action = SCNAction.rotateTo(x: 0.0, y: 0.0, z: -CGFloat.pi/4.0, duration: self.rollDuration, usesShortestUnitArc: true)
        
        action.timingMode = .easeOut
        
        return action
        
    }()
    
    lazy var pitchUpAction: SCNAction = {
        
        let action = SCNAction.rotateTo(x: CGFloat.pi/4.0, y: 0, z: 0.0, duration: pitchDuration, usesShortestUnitArc: true)
        
        action.timingMode = .easeOut
        
        return action
        
    }()
    
    lazy var pitchDownAction: SCNAction = {
        
        let action = SCNAction.rotateTo(x: -CGFloat.pi/4.0, y: 0.00, z: 0.0, duration: pitchDuration, usesShortestUnitArc: true)
        
        action.timingMode = .easeOut
        
        return action
        
    }()
    
    lazy var restoreDefaultFlightOrientationAction: SCNAction = {
        
        let action = SCNAction.rotateTo(x: 0.0, y: 0.0, z: 0.0, duration: self.restoreDuration, usesShortestUnitArc: true)
        
        action.timingMode = .easeIn
        
        return action
        
    }()
    

    
    lazy var moveUpAction: SCNAction = {
        
        return SCNAction.moveBy(x: 0.0, y: self.movementDistance, z: 0.00, duration: moveDuration)
        
    }()
    
    lazy var moveDownAction: SCNAction = {
        
        return SCNAction.moveBy(x: 0.0, y: -self.movementDistance, z: 0.0, duration: moveDuration)
        
    }()
    
    
    lazy var moveLeftAction: SCNAction = {
        
        return SCNAction.moveBy(x: -self.movementDistance, y: 0.0, z: 0.0, duration: moveDuration)
        
        
    }()
    
    lazy var moveRightAction: SCNAction = {
        return SCNAction.moveBy(x: self.movementDistance, y: 0.0, z: 0.0, duration: moveDuration)
        
        
    }()
    
   
    
    
    var rollLeftAnimation: SCNAction{
        let action1 = SCNAction.group([self.rollLeftAction,self.moveLeftAction])
        let action2 = self.restoreDefaultFlightOrientationAction
        
        return SCNAction.sequence([action1,action2])
    }
    
    var rollRightAnimation: SCNAction{
        let action1 = SCNAction.group([self.rollRightAction,self.moveRightAction])
        let action2 = self.restoreDefaultFlightOrientationAction
        
        return SCNAction.sequence([action1,action2])
        
    }
    
    var pitchUpAnimation: SCNAction{
     
        let action1 = SCNAction.group([self.pitchUpAction,self.moveUpAction])
        
        let action2 = self.restoreDefaultFlightOrientationAction
        
        return SCNAction.sequence([action1,action2])
        
    }
    
    var pitchDownAnimation: SCNAction{
        let action1 =  SCNAction.group([self.pitchDownAction,self.moveDownAction])
        
        let action2 = self.restoreDefaultFlightOrientationAction
        
        return SCNAction.sequence([action1,action2])


        
    }
    
    
    
    
    @objc func handleGesture(_ sender: UISwipeGestureRecognizer){
        
        //TODO: only if in playing state
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.up:
            pitchDown()
            break
        case UISwipeGestureRecognizerDirection.left:
            rollLeft()
            break
        case UISwipeGestureRecognizerDirection.down:
            pitchUp()
            break
        case UISwipeGestureRecognizerDirection.right:
            rollRight()
            break
        default:
            break
        }
        
    }
    
    
    func pitchUp(){
        node.runAction(self.pitchUpAnimation)
    }
    
    func pitchDown(){
        node.runAction(self.pitchDownAnimation)
    }
    
    func rollLeft(){
        
        node.runAction(self.rollLeftAnimation)
    }
    
    func rollRight(){
        
        node.runAction(self.rollRightAnimation)
    }
    
    
    func flyForward(){
        
        self.node.runAction(self.moveForwardAction)
    
    }

    
    func propelForward(){
        print("Propelling plane forward...")
        let forwardVector = SCNVector3(0.0, 0.0, -self.forwardSpeed*100)
        self.node.physicsBody?.applyForce(forwardVector, asImpulse: true)
        
    }
    
}
