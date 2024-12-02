//
//  UserDefaults.swift
//  Task Manager
//
//  Created by SASINDERAN N on 02/12/24.
//

import Foundation


class UserDefault {
    
    static var currentAccountId : Int64 {
        get {
            return UserDefaults.standard.value(forKey: "userId") as! Int64
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "userId")
        }
    }
}
