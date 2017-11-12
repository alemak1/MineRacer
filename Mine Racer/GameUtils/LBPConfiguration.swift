//
//  LBPConfiguration.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit


/** LBP Configuration structs provide a wrapper for the configuration data needed to generate spawn points and initial velocities based on a pre-defined, cubic spawning region **/

struct LBPConfiguration{
    
    var leftBoundaryPoint: FlightBoundaryPoint
    var rightBoundaryPoint: FlightBoundaryPoint
    var ceilingBoundaryPoint: FlightBoundaryPoint
    var floorBoundaryPoint: FlightBoundaryPoint
    var nearZBoundary: FlightBoundaryPoint
    var farZBoundary: FlightBoundaryPoint
    
    var minVelocity: Int
    var maxVelocity: Int
    
    init(leftBoundaryDistance: Int, rightBoundaryDistance: Int, topBoundaryDistance: Int, floorBoundaryDistance: Int, nearZBoundaryDistance: Int, farZBoundaryDistance: Int, minVelocity: Int = 2, maxVelocity: Int = 5){
        
        self.leftBoundaryPoint = FlightBoundaryPoint.LeftBoundary(leftBoundaryDistance)
        self.rightBoundaryPoint = FlightBoundaryPoint.RightBoundary(rightBoundaryDistance)
        self.ceilingBoundaryPoint = FlightBoundaryPoint.CeilingBoundary(topBoundaryDistance)
        self.floorBoundaryPoint = FlightBoundaryPoint.FloorBoundary(floorBoundaryDistance)
        self.nearZBoundary = FlightBoundaryPoint.NearZBoundary(nearZBoundaryDistance)
        self.farZBoundary = FlightBoundaryPoint.FarZBoundary(farZBoundaryDistance)
        self.maxVelocity = maxVelocity
        self.minVelocity = minVelocity
    }
    
    /** Helper functions for getting the boundaries of a cubic region that defines the spawning area for an enemy **/
    
    func getLeftBoundaryDistance() -> Int{
        return self.leftBoundaryPoint.getBoundaryDistance()
    }
    
    func getRightBoundaryDistance() -> Int{
        return self.rightBoundaryPoint.getBoundaryDistance()
    }
    
    func getTopBoundaryDistance() -> Int{
        return self.ceilingBoundaryPoint.getBoundaryDistance()
    }
    
    func getBottomBoundaryDistance() -> Int{
        return self.floorBoundaryPoint.getBoundaryDistance()
    }
    
    func getNearZBoundaryDistance() -> Int{
        return self.nearZBoundary.getBoundaryDistance()
    }
    
    func getFarZBoundaryDistance() -> Int{
        return self.farZBoundary.getBoundaryDistance()
    }
    
    
  
    func getRandomVelocityVector() -> SCNVector3{
        
        let velocityRange = maxVelocity - minVelocity
        
        let zVelocity = Int(arc4random_uniform(UInt32(velocityRange))) + minVelocity
        
        return SCNVector3(0, 0,zVelocity)
        
    }
    
    
    func getRandomSpawnPointVector() -> SCNVector3{
        
        let (x,y,z) = getRandomSpawnPoint()
        
        return SCNVector3(x, y, z)
    }
    
 
    func getRandomSpawnPoint() -> (Int,Int,Int){
        
        
        
        let hDistance = self.rightBoundaryPoint.getBoundaryDistance() - self.leftBoundaryPoint.getBoundaryDistance()
        let spawnPointX = self.leftBoundaryPoint.getBoundaryDistance() + Int(arc4random_uniform(UInt32(hDistance)))
        
        let vDistance = self.ceilingBoundaryPoint.getBoundaryDistance() - self.floorBoundaryPoint.getBoundaryDistance()
        let spawnPointY = self.floorBoundaryPoint.getBoundaryDistance() + Int(arc4random_uniform(UInt32(vDistance)))
        
        
        let zDistance = self.nearZBoundary.getBoundaryDistance() - self.farZBoundary.getBoundaryDistance()
        
        let spawnPointZ = self.nearZBoundary.getBoundaryDistance() - Int(arc4random_uniform(UInt32(zDistance)))
        
        return (spawnPointX,spawnPointY,spawnPointZ)
    }
    
    static let DefaultLBPConfiguration = LBPConfiguration(leftBoundaryDistance: -50, rightBoundaryDistance: 50, topBoundaryDistance: 50, floorBoundaryDistance: -50, nearZBoundaryDistance: -300, farZBoundaryDistance: -400)
    
    static let SpikeBallDefaultConfiguration = LBPConfiguration(leftBoundaryDistance: -20, rightBoundaryDistance: 20, topBoundaryDistance: 20, floorBoundaryDistance: -20, nearZBoundaryDistance: -300, farZBoundaryDistance: -400, minVelocity: 6, maxVelocity: 12)
    
    static let HighVelocityNarrowHeightAndWidthConfiguration = LBPConfiguration(leftBoundaryDistance: -20, rightBoundaryDistance: 20, topBoundaryDistance: 20, floorBoundaryDistance: -20, nearZBoundaryDistance: -300, farZBoundaryDistance: -400, minVelocity: 20, maxVelocity: 36)
    
    static let LowVelocityNarrowHeightAndWidthConfiguration = LBPConfiguration(leftBoundaryDistance: -20, rightBoundaryDistance: 20, topBoundaryDistance: 20, floorBoundaryDistance: -20, nearZBoundaryDistance: -300, farZBoundaryDistance: -400, minVelocity: 10, maxVelocity: 20)
    
    static let LowVelocityLargeHeightAndLargeWidthConfiguration = LBPConfiguration(leftBoundaryDistance: -100, rightBoundaryDistance: 100, topBoundaryDistance: 100, floorBoundaryDistance: -100, nearZBoundaryDistance: -300, farZBoundaryDistance: -400, minVelocity: 10, maxVelocity: 20)
    
    static let HighVelocityLargeHeightAndWidthConfiguration = LBPConfiguration(leftBoundaryDistance: -50, rightBoundaryDistance: 50, topBoundaryDistance: 50, floorBoundaryDistance: -50, nearZBoundaryDistance: -300, farZBoundaryDistance: -400, minVelocity: 22, maxVelocity: 36)
    
    
    static func GetDefaultBoundaryDistance(flightBoundaryPoint: FlightBoundaryPoint) -> Int{
        
        switch flightBoundaryPoint {
        case .CeilingBoundary(_):
            return LBPConfiguration.DefaultLBPConfiguration.getTopBoundaryDistance()
        case .FloorBoundary(_):
            return LBPConfiguration.DefaultLBPConfiguration.getBottomBoundaryDistance()
        case .LeftBoundary(_):
            return LBPConfiguration.DefaultLBPConfiguration.getLeftBoundaryDistance()
        case .RightBoundary(_):
            return LBPConfiguration.DefaultLBPConfiguration.getRightBoundaryDistance()
        case .NearZBoundary(_):
            return LBPConfiguration.DefaultLBPConfiguration.getNearZBoundaryDistance()
        case .FarZBoundary(_):
            return LBPConfiguration.DefaultLBPConfiguration.getFarZBoundaryDistance()
        }
    }
}

/**
 **/

