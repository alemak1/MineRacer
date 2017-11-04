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
    case Player = 1
    case Enemy = 2
    case Obstacle = 4
    case Front = 8
    case Back = 16
    case Left = 32
    case Right = 64
    case LetterBox = 128
    case PowerUp = 256
}
