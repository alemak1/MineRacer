//
//  VelocityType.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/11/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


enum VelocityType{
    case LowVelocityNHNW, HighVelocityNHNW, LowVelocityLHLW, HighVelocityLHLW
    
    static let allVelocityTypes: [VelocityType]  = [.LowVelocityNHNW,.HighVelocityNHNW,.LowVelocityLHLW,.HighVelocityLHLW]
    
    static func getRandomVelocityType() -> VelocityType{
        let totalTypes = VelocityType.allVelocityTypes.count
        let randomIdx = Int(arc4random_uniform(UInt32(totalTypes)))
        
        return VelocityType.allVelocityTypes[randomIdx]
    }
    
    static func getDefaultVelocityType() -> VelocityType{
        
  
        return .LowVelocityLHLW
    }
}
