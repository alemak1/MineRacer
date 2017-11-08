//
//  SCNVector3+Extension.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/8/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3{
    
    
    func multiplyByScalar(scalar: Float) -> SCNVector3{
        
        return SCNVector3(scalar*self.x, scalar*self.y, scalar*self.z)
    }
    
    func getDifference(withVector anotherVector: SCNVector3) -> SCNVector3{
        
        let dx = anotherVector.x - self.x
        let dy = anotherVector.y - self.y
        let dz = anotherVector.z - self.z
        
        return SCNVector3(dx, dy, dz)
    }
}
