//
//  BasicCharacter.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/4/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class BasicCharacter{
    
    var node: SCNNode!
    
    //MARK: ************ Configure Collision Nodes for Character
    
    var collisionNode: SCNNode!
    var frontCollisionNode: SCNNode!
    var bacCollisionkNode: SCNNode!
    var rightCollisionNode: SCNNode!
    var leftCollisionNode: SCNNode!
    
    
    //MARK: ************* Parameters for Configuring Character Actions
    
    var turnDuration = 0.50
    var moveDuration = 0.50
    var movementDistance: CGFloat = 5.00
    
    //MARK: ************* Initializers
    
    init(withReferenceNode referenceNode: SCNNode, collisionReferenceNode: SCNNode) {
        node = referenceNode
        node.name = "basicCharacter"
        
        collisionNode = collisionReferenceNode
        
        frontCollisionNode = collisionNode.childNode(withName: "Front", recursively: true)!
        bacCollisionkNode = collisionNode.childNode(withName: "Back", recursively: true)!
        leftCollisionNode = collisionNode.childNode(withName: "Left", recursively: true)!
        rightCollisionNode = collisionNode.childNode(withName: "Right", recursively: true)!


        
    }
    
    
    func updateCollisionNodePosition(){
        collisionNode.position = node.position
        collisionNode.rotation = node.rotation
    }
    
    //MARK:  *********** Configure Character Actions

    lazy var turnLeftAction: SCNAction = {
        
        return SCNAction.rotateTo(x: 0.0, y: CGFloat.pi/2.0, z: 0.0, duration: self.turnDuration, usesShortestUnitArc: true)
    }()
    
    lazy var turnRightAction: SCNAction = {
        
        return SCNAction.rotateTo(x: 0.0, y: -CGFloat.pi/2.0, z: 0.0, duration: turnDuration, usesShortestUnitArc: true)

    }()
    
    lazy var turnForwardAction: SCNAction = {
        
        return SCNAction.rotateTo(x: 0.0, y: 0, z: 0.0, duration: turnDuration, usesShortestUnitArc: true)

    }()
    
    lazy var turnBackwardAction: SCNAction = {
        
        return SCNAction.rotateTo(x: 0.0, y: CGFloat.pi, z: 0.0, duration: turnDuration, usesShortestUnitArc: true)

    }()
    
    lazy var moveForwardAction: SCNAction = {
        
        return SCNAction.moveBy(x: 0.0, y: 0.0, z: -movementDistance, duration: moveDuration)
        
    }()
    
    lazy var moveBackwardAction: SCNAction = {
        
        return SCNAction.moveBy(x: 0.0, y: 0.0, z: movementDistance, duration: moveDuration)

    }()
    
    
    lazy var moveLeftAction: SCNAction = {
        
        return SCNAction.moveBy(x: -movementDistance, y: 0.0, z: 0.0, duration: moveDuration)

        
    }()
    
    lazy var moveRightAction: SCNAction = {
        return SCNAction.moveBy(x: movementDistance, y: 0.0, z: 0.0, duration: moveDuration)

        
    }()
    
  
    lazy var jumpUpAction: SCNAction = {
        
        let jumpUpVector = SCNVector3(x: 0.0, y: 1.0, z: 0.0)
        let jumpUpAction = SCNAction.move(to: jumpUpVector, duration: 0.25)
        jumpUpAction.timingMode = .easeOut
        
        
        return jumpUpAction
    }()
    
    lazy var jumpDownAction: SCNAction = {
        
        let jumpDownVector = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
        let jumpDownAction = SCNAction.move(to: jumpDownVector, duration: 0.25)
        jumpDownAction.timingMode = .easeIn
        
        return jumpDownAction
    }()
    
    
    var jumpAction: SCNAction{
        return SCNAction.sequence([jumpUpAction,jumpDownAction])
    }
    
  
    var jumpLeftAction: SCNAction{
        return SCNAction.group([turnLeftAction,moveLeftAction])
    }
    
    var jumpRightAction: SCNAction{
        return SCNAction.group([turnRightAction,moveRightAction])

    }
    
    var jumpForwardAction: SCNAction{
        return SCNAction.group([turnForwardAction,moveForwardAction])

    }
    
    var jumpBackwardsAction: SCNAction{
        return SCNAction.group([turnBackwardAction,moveBackwardAction])

    }
    
   
    
    
    @objc func handleGesture(_ sender: UISwipeGestureRecognizer){
        
        //TODO: only if in playing state
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.up:
            moveForward()
            break
        case UISwipeGestureRecognizerDirection.left:
            moveLeft()
            break
        case UISwipeGestureRecognizerDirection.down:
            moveBackward()
            break
        case UISwipeGestureRecognizerDirection.right:
            moveRight()
            break
        default:
            break
        }
        
    }
    
    
    func moveForward(){
        node.runAction(self.jumpForwardAction)
    }
    
    func moveBackward(){
        node.runAction(self.jumpBackwardsAction)
    }
    
    func moveLeft(){
        
        node.runAction(self.jumpLeftAction)
    }
    
    func moveRight(){
        
        node.runAction(self.jumpRightAction)
    }
    
    
    func jump(){
        node.runAction(self.jumpAction)
    }
    
   
}
