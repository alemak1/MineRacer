//
//  BoundaryPoints.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


enum FlightBoundaryPoint{
    
    
    typealias LBPConfiguration = (
        ceiling: FlightBoundaryPoint,
        floor: FlightBoundaryPoint,
        left: FlightBoundaryPoint,
        right: FlightBoundaryPoint,
        nearZ: FlightBoundaryPoint,
        farZ: FlightBoundaryPoint
    )
    
    typealias BoundaryDistances = (
        ceiling: Int,
        floor: Int,
        left: Int,
        right: Int,
        nearZ: Int,
        farZ: Int
    )
    
    static let DefaultBoundaryConfiguration: LBPConfiguration = (
        FlightBoundaryPoint.CeilingBoundary(50),
        FlightBoundaryPoint.FloorBoundary(-50),
        FlightBoundaryPoint.LeftBoundary(-50),
        FlightBoundaryPoint.RightBoundary(50),
        FlightBoundaryPoint.NearZBoundary(-300),
        FlightBoundaryPoint.FarZBoundary(-400)
    )
    
    static let WideBoundaryConfiguration: LBPConfiguration = (
        FlightBoundaryPoint.CeilingBoundary(30),
        FlightBoundaryPoint.FloorBoundary(-30),
        FlightBoundaryPoint.LeftBoundary(-50),
        FlightBoundaryPoint.RightBoundary(50),
        FlightBoundaryPoint.NearZBoundary(-300),
        FlightBoundaryPoint.FarZBoundary(-400)
    )
    
    static let NarrowBoundaryConfiguration: LBPConfiguration = (
        FlightBoundaryPoint.CeilingBoundary(150),
        FlightBoundaryPoint.FloorBoundary(-150),
        FlightBoundaryPoint.LeftBoundary(-30),
        FlightBoundaryPoint.RightBoundary(30),
        FlightBoundaryPoint.NearZBoundary(-300),
        FlightBoundaryPoint.FarZBoundary(-400)
    )
    
    static func GetDefaultBoundaryDistances() -> BoundaryDistances{
        
        return (
            FlightBoundaryPoint.DefaultBoundaryConfiguration.ceiling.getBoundaryDistance(),
            FlightBoundaryPoint.DefaultBoundaryConfiguration.floor.getBoundaryDistance(),
            FlightBoundaryPoint.DefaultBoundaryConfiguration.left.getBoundaryDistance(),
            FlightBoundaryPoint.DefaultBoundaryConfiguration.right.getBoundaryDistance(),
            FlightBoundaryPoint.DefaultBoundaryConfiguration.nearZ.getBoundaryDistance(),
            FlightBoundaryPoint.DefaultBoundaryConfiguration.farZ.getBoundaryDistance()
        )
    }
    
    static func GetNarrowBoundaryDistances() -> BoundaryDistances{
        
        return (
            FlightBoundaryPoint.NarrowBoundaryConfiguration.ceiling.getBoundaryDistance(),
            FlightBoundaryPoint.NarrowBoundaryConfiguration.floor.getBoundaryDistance(),
            FlightBoundaryPoint.NarrowBoundaryConfiguration.left.getBoundaryDistance(),
            FlightBoundaryPoint.NarrowBoundaryConfiguration.right.getBoundaryDistance(),
            FlightBoundaryPoint.NarrowBoundaryConfiguration.nearZ.getBoundaryDistance(),
            FlightBoundaryPoint.NarrowBoundaryConfiguration.farZ.getBoundaryDistance()
        )
    }
    
    static func GetWideBoundaryDistances() -> BoundaryDistances{
        
        return (
            FlightBoundaryPoint.WideBoundaryConfiguration.ceiling.getBoundaryDistance(),
            FlightBoundaryPoint.WideBoundaryConfiguration.floor.getBoundaryDistance(),
            FlightBoundaryPoint.WideBoundaryConfiguration.left.getBoundaryDistance(),
            FlightBoundaryPoint.WideBoundaryConfiguration.right.getBoundaryDistance(),
            FlightBoundaryPoint.WideBoundaryConfiguration.nearZ.getBoundaryDistance(),
            FlightBoundaryPoint.WideBoundaryConfiguration.farZ.getBoundaryDistance()

        )
    }
    
    case LeftBoundary(Int)
    case RightBoundary(Int)
    case CeilingBoundary(Int)
    case FloorBoundary(Int)
    case NearZBoundary(Int)
    case FarZBoundary(Int)
    
    func getBoundaryDistance() -> Int{
        
        switch self {
        case .LeftBoundary(let x):
            return x
        case .RightBoundary(let x):
            return x
        case .CeilingBoundary(let x):
            return x
        case .FloorBoundary(let x):
            return x
        case .NearZBoundary(let x):
            return x
        case .FarZBoundary(let x):
            return x
        }
    }

}

