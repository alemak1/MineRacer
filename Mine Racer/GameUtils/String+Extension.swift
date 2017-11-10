//
//  String+Extension.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/9/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

extension String{
    
    /** Helper function to get a random letter type for a given string **/
    
    func getRandomLetterType() -> LetterType{
        
        let chars = self.characters.map({$0}) //Convert word to an array of characters
        let letterTypes = chars.map({ return LetterType(rawValue: "letter_\($0)")! })
        
        let totalLetterTypes = letterTypes.count
        let randomIdx = Int(arc4random_uniform(UInt32(totalLetterTypes)))
        let randomLetterType = letterTypes[randomIdx]
        
        return randomLetterType
    }
    
}
