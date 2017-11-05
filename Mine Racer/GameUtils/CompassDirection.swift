//
//  CompassDirection.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/4/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import Foundation
import CoreGraphics

enum CompassDirection: Int{
    
    case east = 0, eastByNorthEast, northEast, northByNorthEast
    case north, northByNorthWest, northWest, westByNorthWest
    case west, westBySouthWest,southWest,southBySouthWest
    case south, southBySouthEast,southEast,eastBySouthEast
    
    static let allDirections: [CompassDirection] = [
        .east, .eastByNorthEast, .northEast, .northByNorthEast,
        .north, .northByNorthWest, .northWest, .westByNorthWest,
        .west, .westBySouthWest, .southWest, .southBySouthWest,
        .south, .eastBySouthEast, .southEast, .eastBySouthEast
    ]
    
    var zRotation: CGFloat{
        let stepSize = CGFloat((Double.pi*2))/CGFloat(CompassDirection.allDirections.count)
        
        return CGFloat(self.rawValue)*stepSize
    }
    
    
    
    init(zRotation: CGFloat) {
        
        let twoPi = Double.pi * 2
        
        // Normalize the node's rotation.
        let rotation = (Double(zRotation) + twoPi).truncatingRemainder(dividingBy: twoPi)
        
        // Convert the rotation of the node to a percentage of a circle.
        let orientation = rotation / twoPi
        
        // Scale the percentage to a value between 0 and 15.
        let rawFacingValue = round(orientation * 16.0).truncatingRemainder(dividingBy: 16.0)
        
        // Select the appropriate `CompassDirection` based on its members' raw values, which also run from 0 to 15.
        self = CompassDirection(rawValue: Int(rawFacingValue))!
    }
    
    init(string: String) {
        switch string {
        case "North":
            self = .north
            
        case "NorthEast":
            self = .northEast
            
        case "East":
            self = .east
            
        case "SouthEast":
            self = .southEast
            
        case "South":
            self = .south
            
        case "SouthWest":
            self = .southWest
            
        case "West":
            self = .west
            
        case "NorthWest":
            self = .northWest
            
        default:
            fatalError("Unknown or unsupported string - \(string)")
        }
    }
    
    
    static func GetRandomDirection() -> CompassDirection{
        
        let maxDirections = allDirections.count
        let randomDirection = Int(arc4random_uniform(UInt32(maxDirections)))
        
        return allDirections[randomDirection]
        
    }
    
}

