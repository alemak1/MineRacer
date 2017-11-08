//
//  CollisionMask.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/4/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit


enum CollisionMask: UInt32{
    case None = 0
    case Player = 1
    case Enemy = 2
    case Barrier = 4
    case PortalCenter = 8
    case Letter = 16
    case Fuel = 32
    case PowerUp = 64
    case Obstacle = 128
    case Other = 256
}
