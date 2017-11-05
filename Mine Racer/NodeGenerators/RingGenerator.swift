//
//  RingGenerator.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class RingGenerator{
    
    
    static func GenerateRingNode(ofLetterType letterType: LetterType,ofLetterStyle letterStyle: LetterStyle, ringRadius: CGFloat, pipeRadius: CGFloat) -> SCNNode{
    
        
    
        let ring = SCNTorus(ringRadius: ringRadius, pipeRadius: pipeRadius)
        
        let textureBasePath =  String("art.scnassets/").appending(letterStyle.rawValue).appending("/")
        let texturePath = textureBasePath.appending(letterType.rawValue)
        let fullTexturePath = texturePath.appending(".png")
        
        ring.materials.first?.diffuse.contents = fullTexturePath
        ring.materials.first?.diffuse.wrapS = .repeat
        ring.materials.first?.diffuse.wrapT = .repeat
        
        let ringNode = SCNNode(geometry: ring)
        ringNode.rotation = SCNVector4(1.0, 0.0, 0.0, CGFloat.pi/2.0)
        let cubeLength = ringRadius/2.0
        
        /** Configure a cube node as a hidden geometry to act as a contact node for the plane **/
        
        let portalCube = SCNBox(width: cubeLength, height: cubeLength, length: cubeLength, chamferRadius: 0.0)
        
        let portalContactNode = SCNNode(geometry: portalCube)
        
        /** For development, the node should still be visible; for production, set opacity to zero **/
        
        portalContactNode.opacity = 0.50
        
        /** Configure physics properties of the contact node **/
        
        let physicsShape = SCNPhysicsShape(geometry: portalCube, options: nil)
        portalContactNode.physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        portalContactNode.physicsBody?.categoryBitMask = Int(CollisionMask.PortalCenter.rawValue)
        
        /** Add the contact node as a child of the ring and center it in the middle of the ring **/
        
        ringNode.addChildNode(portalContactNode)
        portalContactNode.position = SCNVector3.init(x: 0.0, y: 0.0, z: 0.0)
        
        
        return ringNode
    }
}
