//
//  BackgroundManager.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/17/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

class BackgroundManager{
    
    enum SkyBoxType: String{
        case sky1,sky2,sky3,sky4,sky5
        
        static let allSkyBoxes: [SkyBoxType] = [.sky1,.sky2,.sky3,.sky4,.sky5]
        
        static func getRandomSkyBoxType() -> SkyBoxType{
            
            return SkyBoxType.allSkyBoxes.getRandomElement() as! SkyBoxType
        }
        
    }
    
    enum SkyBoxOrientation: String{
        case left,right,top,back,front
        
        static let allSkyBoxOrientations: [SkyBoxOrientation] = [.left,.right,.top,.back,.front]
        
        static func getRandomOrientation() -> SkyBoxOrientation{
            
            return SkyBoxOrientation.allSkyBoxOrientations.getRandomElement() as! SkyBoxOrientation
        }
        
    }
    
    static func GetRandomSkyBoxPath() -> String{
        
        let randomSkyBoxOrientation = SkyBoxOrientation.getRandomOrientation()
        let randomSkyBoxType = SkyBoxType.getRandomSkyBoxType()
        
        return BackgroundManager.GetSkyBoxPath(forSkyBoxOrientation: randomSkyBoxOrientation, andForSkyBoxType: randomSkyBoxType)
    }


    static func GetSkyBoxPath(forSkyBoxOrientation skyBoxOrientation: SkyBoxOrientation, andForSkyBoxType skyBoxType: SkyBoxType) -> String{
        
        let basePath = skyBoxType.rawValue
        let modifiedPath = "\(basePath)/\(basePath)_\(skyBoxOrientation.rawValue).jpg"
        let fullPath = "art.scnassets/skies/\(modifiedPath)"
        
        return fullPath
    }
    

}
