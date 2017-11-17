//
//  QueueManager.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/16/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

/**

class QueueManager{
    
    let operationQueue: OperationQueue = OperationQueue()
    
    var firstEncounter: Encounter
    var planeViewController: PlaneViewController
    
    var currentEncounter: Encounter?
    var operations = [Operation]()
    
    init(withPlaneViewController planeViewController: PlaneViewController,withEncounter firstEncounter: Encounter){
        self.planeViewController = planeViewController
        self.firstEncounter = firstEncounter
        self.currentEncounter = firstEncounter
        
        loadOperationsFromEncounter()
        loadQueueWithOperations()
    }
    
    func start(){
        if(operations.isEmpty){
            print("Error: there are no operations in this queue")
            return
        }
        
        operationQueue.operations.first!.start()
    }
    
    func cancelOperations(){
        
        if(operations.isEmpty){
            return
        }
        
        operationQueue.cancelAllOperations()
        operations.removeAll()
    }
    
    private func loadQueueWithOperations(){
        
        if(operations.isEmpty){
            return
        }
        
        operationQueue.addOperations(operations, waitUntilFinished: false)

        
    }
    
    private func getOperation(forEncounter encounter: Encounter) -> Operation{
        
        return BlockOperation(block: {
            
            let waitTime = encounter.waitTime
            
            print("Preparing to execute next encounter....")
            
        
            DispatchQueue.global().asyncAfter(deadline: .now() + waitTime, execute: {
                
                
                if(GameHelper.sharedInstance.state != .Playing || self.planeViewController.scnScene.isPaused || self.planeViewController.worldNode.isPaused){
                    return
                }
                
                
                if let numberOfSpikeBalls = encounter.numberOfSpikeBalls{
                    self.planeViewController.spikeBallManager.addRandomSpikeBalls(number: numberOfSpikeBalls)
                }
                
                if let numberOfSpaceCraft = encounter.numberOfSpaceCraft{
                    self.planeViewController.spaceCraftManager.addRandomSpaceCraft(number: numberOfSpaceCraft)
                }
                
                if let numberOfLetters = encounter.numberOfLetters{
                    
                    self.planeViewController.letterRingManager.addRandomizedMovingRing(with: numberOfLetters, fromWord: self.planeViewController.currentWord)
                }
                
                if let numberOfFireballs = encounter.numberOfFireballs{
                    self.planeViewController.fireballManager.addRandomFireballs(number: numberOfFireballs)
                }
                
                if let numberOfTurrets = encounter.numberOfTurrets{
                    self.planeViewController.turretManager.addRandomTurrets(number: numberOfTurrets)
                }
                
                
            })
                
           
          
            
        })
    }
    
    
    private func loadOperationsFromEncounter(){
       
        if(currentEncounter == nil){
            return
        }
        
        let anotherOperation = getOperation(forEncounter: currentEncounter!)
        
        /**
        if(!operations.isEmpty && operations.count > 0){
                let lastOperation = operations.last!
                anotherOperation.addDependency(anotherOperation)
        }
        **/
        
        operations.append(anotherOperation)
        
        if let nextEncounter = firstEncounter.getNextEncounter(){
            
            currentEncounter = nextEncounter
            loadOperationsFromEncounter()
        }
        
    }
}
**/
