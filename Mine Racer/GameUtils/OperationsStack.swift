//
//  OperationsStack.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/16/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

class OperationStack{
    
    var operations = [Operation]()
    
    func addOperation(nextOperation: Operation){
        
        if(operations.isEmpty){
           
            operations.append(nextOperation)
        
        } else {
            
            let lastOperation = operations.last!
            nextOperation.addDependency(lastOperation)
            
        }
        
    }
    
    func insertOperationAt(index: Int){
     
        
    }
    
    func popOperation() -> Operation?{
        
        if(operations.isEmpty){
            return nil
        } else {
            return operations.popLast()
        }
        
        
    }
}
