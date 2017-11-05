//
//  LetterEnum.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit


enum LetterStyle: String{
    case Blue
    case Brown
    case Metal
    case Yellow
    case Marble
    case Wood
    case SolidLetterWithYellowBorder
    case EmptyLetterWithYellowBorder
    
    static let allLetterStyles: [LetterStyle] = [.Blue, .Brown,.Metal,.Yellow,.Marble,.Wood,.SolidLetterWithYellowBorder, .EmptyLetterWithYellowBorder]
    
    static func GetRandomLetterStyle() -> LetterStyle{
        
        let randomIdx = Int(arc4random_uniform(UInt32(LetterStyle.allLetterStyles.count)))
        
        return LetterStyle.allLetterStyles[randomIdx]
    }
    
}

enum LetterType: String{
    case letter_A, letter_B, letter_C, letter_D, letter_E, letter_F, letter_G, letter_H, letter_I
    case letter_J, letter_K, letter_L, letter_M, letter_N, letter_O, letter_P, letter_Q, letter_R
    case letter_S, letter_T, letter_U, letter_V, letter_W, letter_X, letter_Y, letter_Z
    
    static let allLetters: [LetterType] = [
        .letter_A, .letter_B, .letter_C, .letter_D, .letter_E, .letter_F, .letter_G, .letter_H, .letter_I, .letter_J, .letter_K, .letter_L, .letter_M, .letter_N, .letter_O, .letter_P, .letter_Q, .letter_R, .letter_S, .letter_T, .letter_U, .letter_V, .letter_W, .letter_X, .letter_Y, .letter_Z
    ]
    
    static func GetRandomLetterType() -> LetterType{
        
        let randomIdx = Int(arc4random_uniform(UInt32(LetterType.allLetters.count)))
        
        return LetterType.allLetters[randomIdx]
    }
}


