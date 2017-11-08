//
//  LBPConfiguration.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


struct LBPConfiguration{
    
    var leftBoundaryPoint: FlightBoundaryPoint
    var rightBoundaryPoint: FlightBoundaryPoint
    var ceilingBoundaryPoint: FlightBoundaryPoint
    var floorBoundaryPoint: FlightBoundaryPoint
    var nearZBoundary: FlightBoundaryPoint
    var farZBoundary: FlightBoundaryPoint
    
    init(leftBoundaryDistance: Int, rightBoundaryDistance: Int, topBoundaryDistance: Int, floorBoundaryDistance: Int, nearZBoundaryDistance: Int, farZBoundaryDistance: Int){
        
        self.leftBoundaryPoint = FlightBoundaryPoint.LeftBoundary(leftBoundaryDistance)
        self.rightBoundaryPoint = FlightBoundaryPoint.RightBoundary(rightBoundaryDistance)
        self.ceilingBoundaryPoint = FlightBoundaryPoint.CeilingBoundary(topBoundaryDistance)
        self.floorBoundaryPoint = FlightBoundaryPoint.FloorBoundary(floorBoundaryDistance)
        self.nearZBoundary = FlightBoundaryPoint.NearZBoundary(nearZBoundaryDistance)
        self.farZBoundary = FlightBoundaryPoint.FarZBoundary(farZBoundaryDistance)
    }
    
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

