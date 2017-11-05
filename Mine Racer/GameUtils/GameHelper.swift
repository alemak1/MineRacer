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
    
    var state: GameState = .TapToPlay
}
