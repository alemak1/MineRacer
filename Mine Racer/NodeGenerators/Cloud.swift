//
//  Cloud.swift
//  Alien Sniper Defense 3D
//
//  Created by Aleksander Makedonski on 10/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class CloudGenerator{
    
    
    enum MenuNodeType: String{
        
        case restartGameCloud
        case saveGameCloud
        case nextLevelCloud
        case pauseGameCloud
        case backMainMenuCloud
        case gameWinCloud
        case gameLossCloud1
        case gameLossCloud2
        
        func getImagePath() -> String{
            
            return "/art.scnassets/MenuClouds/\(self.rawValue).png"
            
        }
        
        
        
    }
    
    enum CloudType:Int{
    
        case Cloud19 = 19
        case Cloud20
        case Cloud21
        case Cloud22
        case Cloud23
        case Cloud24
        case Cloud25
        case Cloud26
        case Cloud27
        case Cloud28
        case Cloud29
        case Cloud30
        
        
        static let allCloudTypes: [CloudType] = [
            .Cloud19, .Cloud20, .Cloud21, .Cloud22, .Cloud23, .Cloud24, .Cloud25,
            .Cloud26, .Cloud27, .Cloud28, .Cloud29, .Cloud30
        ]
        
        func getImagePath() -> String{
            
           return "/art.scnassets/Clouds/cloud\(self.rawValue).png"
        
        }
        
        
        func getSize() -> CGSize{
            switch self {
            case .Cloud19:
                return CGSize(width: 5.02, height: 0.71)
            case .Cloud20:
                return CGSize(width: 2.73, height: 2.10)
            case .Cloud21:
                return CGSize(width: 3.96, height: 2.30)
            case .Cloud22:
                return CGSize(width: 3.02, height: 2.61)
            case .Cloud23:
                return CGSize(width: 4.06, height: 2.52)
            case .Cloud24:
                return CGSize(width: 3.84, height: 2.74)
            case .Cloud25:
                return CGSize(width: 4.00, height: 3.07)
            case .Cloud26:
                return CGSize(width: 4.54, height: 1.24)
            case .Cloud27:
                return CGSize(width: 5.11, height: 0.65)
            case .Cloud28:
                return CGSize(width: 4.12, height: 0.54)
            case .Cloud29:
                return CGSize(width: 4.45, height: 3.66)
            case .Cloud30:
                return CGSize(width: 3.02, height: 4.22)

            }
        }
    }
    

    static func GetTargetWordCloud(with camerPosition: SCNVector3, string1: String, string2: String, string3: String) -> SCNNode{
        
        let xPos = camerPosition.x
        let yPos = camerPosition.y
        let zPos = camerPosition.z - 3
        
        let spawnPoint = SCNVector3(xPos, yPos, zPos)
        
        let cloud = CloudGenerator.CreateIntroPanelCloud(withString: string1, string2: string2, string3: string3)
        let cloudNode = SCNNode(geometry: cloud)
        
        cloudNode.name = "IntroPanel"
        
        cloudNode.position = spawnPoint
        
        return cloudNode
        
    }
    
    static func CreateRandomCloudNode() -> SCNNode{
        
        let xPos = -4 + Int(arc4random_uniform(UInt32(8)))
        let yPos = 1 + Int(arc4random_uniform(UInt32(10)))
        let zPos = -5 - Int(arc4random_uniform(UInt32(10)))
        
        let spawnPoint = SCNVector3(xPos, yPos, zPos)
        
        
        let cloud = CloudGenerator.CreateRandomCloud()
        let cloudNode = SCNNode(geometry: cloud)
        cloudNode.name = "Cloud"
        
        cloudNode.position = spawnPoint
        
        return cloudNode
    }
    
    
    static func CreateRandomCloud() -> SCNPlane{
        
        let randomIdx = Int(arc4random_uniform(UInt32(CloudType.allCloudTypes.count)))
        
        let randomCloudType =  CloudType.allCloudTypes[randomIdx]
        
        
        return CreateCloud(ofType: randomCloudType)
    }
    
    static func CreateCloud(ofType cloudType: CloudType) -> SCNPlane{
        
        
        let size = cloudType.getSize()
        let plane = SCNPlane(width: size.width, height: size.height)
        let material = SCNMaterial()
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = cloudType.getImagePath()
        plane.materials = [material]
        
        return plane
    }
    
    
    static func CreateMenuCloudNode(withMenuNodeType menuNodeType: MenuNodeType) -> SCNNode{
        
        let plane = CreateMenuCloud(withMenuNodeType: menuNodeType)
        let node = SCNNode(geometry: plane)
        node.name = menuNodeType.rawValue
        
        return node
    }
    
    
    static func CreateIntroPanelCloud(withString string1: String, string2: String, string3: String) -> SCNPlane{
        
        let size = CloudType.Cloud30.getSize()
        
        let plane = SCNPlane(width: size.width, height: size.height)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        let adjustedSceneSize = CGSize(width: screenWidth, height: screenHeight)
        
        let skScene = SKScene(size: adjustedSceneSize)
        skScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        skScene.scaleMode = .aspectFit
        skScene.backgroundColor = SKColor.clear
        
        
        let bgTexture = SKTexture(image: #imageLiteral(resourceName: "cloud30.png"))
        
        let aspectRatio = size.height/size.width
        let cloudWidth = screenWidth
        let cloudHeight = screenWidth*aspectRatio

        let adjustedSize = CGSize(width: cloudWidth, height: cloudHeight)
        let bgSprite = SKSpriteNode(texture: bgTexture, color: .clear, size: adjustedSize)
        
        bgSprite.xScale *= 0.80
        bgSprite.yScale *= 0.80
        
        skScene.addChild(bgSprite)
        
        bgSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bgSprite.position = CGPoint.zero
        
        
        let labelNode1 = SKLabelNode(fontNamed: "Avenir")
        labelNode1.text = string1
        labelNode1.fontSize = 22.0
        labelNode1.fontColor = SKColor.white
        labelNode1.zPosition = 2
        labelNode1.horizontalAlignmentMode = .center
        
        let labelNode2 = SKLabelNode(fontNamed: "Avenir")
        labelNode2.text = string2
        labelNode2.zPosition = 2
        labelNode2.fontColor = SKColor.white
        labelNode2.fontSize = 22.0
        labelNode2.horizontalAlignmentMode = .center
        

        
        let labelNode3 = SKLabelNode(fontNamed: "Avenir")
        labelNode3.text = string3
        labelNode3.zPosition = 2
        labelNode3.fontColor = SKColor.white
        labelNode3.fontSize = 22.0
        labelNode3.horizontalAlignmentMode = .center

       skScene.addChild(labelNode1)
       skScene.addChild(labelNode2)
       skScene.addChild(labelNode3)
        
        labelNode1.position = CGPoint(x: 0.0, y: 40.0)
        labelNode2.position = CGPoint(x: 0.0, y: 0.0)
        labelNode3.position = CGPoint(x: 0.0, y: -40.0)
        
        let material = SCNMaterial()
        
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        
        plane.materials = [material]
        
        return plane
    }
    
    static func CreateMenuCloud(withMenuNodeType menuNodeType: MenuNodeType) -> SCNPlane{
        
        var size = CloudType.Cloud26.getSize()
        
        if(menuNodeType == .pauseGameCloud){
            size = CGSize(width: size.width/4.00, height: size.height/4.00)
        }
        
        let plane = SCNPlane(width: size.width, height: size.height)
        
        let material = SCNMaterial()
        
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = menuNodeType.getImagePath()
        plane.materials = [material]
        
        print("Plane created: \(plane.description)")
        
        return plane
    }
}
