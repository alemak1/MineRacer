//
//  Notifications+Extension.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/18/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


extension Notification{
    
    static func PostUnPauseNotification(with object: Any?, userInfo: [AnyHashable:Any]?){
        
        let unpauseNotification = Notification.GetUnPauseNotification(with: object, userInfo: userInfo)
        NotificationCenter.default.post(unpauseNotification)
    }
    
    static func PostPauseNotification(with object: Any?, userInfo: [AnyHashable:Any]?){
        
        let pauseNotification = Notification.GetPauseNotification(with: object, userInfo: userInfo)
        NotificationCenter.default.post(pauseNotification)
    }
    
    static func GetPauseNotification(with object: Any?, userInfo: [AnyHashable:Any]?) -> Notification{
        return self.init(name: Notification.Name.GetPauseNotification(), object: object, userInfo: userInfo)
    }
    
    static func GetUnPauseNotification(with object: Any?, userInfo: [AnyHashable:Any]?) -> Notification{
        return self.init(name: Notification.Name.GetUnPauseNotification(), object: object, userInfo: userInfo)
    }
}

extension Notification.Name{
    
    static func GetPauseNotification() -> Notification.Name{
        return self.init("pauseGame")
        
    }
    
    static func GetUnPauseNotification() -> Notification.Name{
        return self.init("unpauseGame")
    }
    
    
}
