//
//  GameHelper.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/4/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


class GameHelper{
    
    static let sharedInstance = GameHelper()
    
    private init(){
        
    }
    
    enum GameState{
        case Playing
        case TapToPlay
        case GameOver
    
    }
    
    enum LevelTrack: String{
        case SpaceShips
        case SpikeBalls
        case FireBalls
        case Turrets
        
    }
    
    enum Difficulty: String{
        case Easy
        case Medium
        case Hard
        
    }

    enum PlaneType: String{
        case yellow, red, blue
        
        func getPlaneReferenceNodeName() -> String{
            switch self {
            case .yellow:
                return "biplane_yellow"
            case .blue:
                return "biplane_blue"
            case .red:
                return "biplane_red"
                
            }
        }
        
        func getFullScenePath() -> String{
            let sceneName = getSceneName()
            
            return "art.scnassets/scenes/\(sceneName)"
        }
        
        func getSceneName() -> String{
            return "\(self.rawValue)_scene.scn"
        }
    }

    var planeType: PlaneType = .blue
    var state: GameState = .TapToPlay
    var difficulty: Difficulty = .Medium
    var levelTrack: LevelTrack = .SpaceShips
    var level: Int = 1
    
}
