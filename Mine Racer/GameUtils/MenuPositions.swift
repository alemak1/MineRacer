//
//  MenuPositions.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/12/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

enum MenuPosition{
    
    case center
    case upper1,upper2,upper3
    case lower1,lower2,lower3
    
    case GameOver
    case PauseMenu
    case GameWin
    
    func getPosition() -> SCNVector3{
        
        switch self {
        case .GameWin,.GameOver,.PauseMenu:
            return SCNVector3.init(-2.0, 4.0, -10.0)
        case .center:
            return SCNVector3.init(-2.0, 0.0, 5.0)
        case .upper1:
            return SCNVector3.init(-2.0, 4.0, 5.0)
        case .upper2:
            return SCNVector3.init(-2.0, 6.0, 5.0)
        case .upper3:
            return SCNVector3.init(-2.0, 8.0, 5.0)
        case .lower1:
            return SCNVector3.init(-2.0, 2.0, 5.0)
        case .lower2:
            return SCNVector3.init(-2.0, 0.0, 5.0)
        case .lower3:
            return SCNVector3.init(-2.0, -6.0, 5.0)
   
        }
    }
}
