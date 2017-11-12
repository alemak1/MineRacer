//
//  HUD.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/11/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit


class HUD{
    
    
    var hudNode: SCNNode!
    var planeViewController: PlaneViewController!

    var currentLives: Int = 5
    
    var label1: SKLabelNode!
    var label2: SKLabelNode!
    var label3: SKLabelNode!
    
    init(withPlaneViewController planeViewController: PlaneViewController){
        self.planeViewController = planeViewController
        
        initializeHUDNode()
    }
    
    func initializeHUDNode(){
        let scene = SKScene(size: UIScreen.main.bounds.size)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.backgroundColor = SKColor.clear
        
        label1 = SKLabelNode(fontNamed: "Avenir")
        label1.text = "Getting lives..."
        scene.addChild(label1)
        label1.horizontalAlignmentMode = .center
        label1.fontSize = 15.0
        label1.fontColor = SKColor.red
        label1.position = CGPoint(x: 0.0, y: 20.0)
        
        label2 = SKLabelNode(fontNamed: "Avenir")
        label2.text = "Getting current word..."
        scene.addChild(label2)
        label2.horizontalAlignmentMode = .center
        label2.fontSize = 15.0
        label2.fontColor = SKColor.red
        label2.position = CGPoint(x: 0.0, y: 0.0)
        
        label3 = SKLabelNode(fontNamed: "Avenir")
        label3.text = "Getting word in progres..."
        scene.addChild(label3)
        label3.horizontalAlignmentMode = .center
        label3.fontSize = 15.0
        label3.fontColor = SKColor.red
        label3.position = CGPoint(x: 0.0, y: -20.0)
        
        let plane = SCNPlane(width: 100.0, height: 100.0)
        let material = SCNMaterial()
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = scene
        plane.materials = [material]
        

        
        hudNode = SCNNode(geometry: plane)
        hudNode.name = "hud"
        hudNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: 3.14159265)

    }
    
    func updateHUD(){
        
        if(self.planeViewController.player.health < 0){
            return
        }
        
        label1.text = String()

        for _ in 0..<self.planeViewController.player.health{
            label1.text!.append("❤️")
        }
        
        label2.text = self.planeViewController.wordInProgress != nil ? "Word in Progress: \(self.planeViewController!.wordInProgress)" : "No Letters Acquired."
        label3.text = self.planeViewController.currentWord != nil ? "Current Word: \(self.planeViewController.currentWord!)" : "Determining new word..."
    }
    
}
