//
//  DataBaseHandler.swift
//  Task Manager
//
//  Created by SASINDERAN N on 30/11/24.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataSetupProtocol: AnyObject {}

extension CoreDataSetupProtocol {
    var managedContext : NSManagedObjectContext? {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func getCurrentUser() -> UserModel? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetailTable")
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = .dictionaryResultType
//        let userIdPredicate = NSPredicate(format: "userId == %@", UserDefault.currentAccountId) // TODO: FIx me
//        fetchRequest.predicate = userIdPredicate
        do {
            if let users = try self.managedContext?.fetch(fetchRequest)  as? [[String:Any]] {
                return UserModel.decodeCoreDataJsonResponse(userJson: users).first
            }
        } catch {
            return nil
        }
        return nil
    }
}

protocol UserDataProtocol: CoreDataSetupProtocol {
    func saveNewEntry(coreDataEntry usrInfo: UserModel)
    func getLoggedInUsers() -> [UserModel]
    func updateUserDetails(usrInfo: UserModel)
}


class UserDataManager : UserDataProtocol {
    
    func getLoggedInUsers() -> [UserModel] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetailTable")
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            if let users = try managedContext?.fetch(fetchRequest) as? [[String:Any]] {
                return UserModel.decodeCoreDataJsonResponse(userJson: users)
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    func saveNewEntry(coreDataEntry usrInfo: UserModel) {
        if let context = managedContext, let entity = NSEntityDescription.entity(forEntityName: "UserDetailTable", in: context) {
            let newUser = NSManagedObject(entity: entity, insertInto: context)
            newUser.setValue(usrInfo.accessToken, forKey: UserCoreDatakeys.accessToken.rawValue)
            newUser.setValue(usrInfo.refreshToken, forKey: UserCoreDatakeys.accessToken.rawValue)
            newUser.setValue(usrInfo.tokenExpiry, forKey: UserCoreDatakeys.tokenExpiry.rawValue)
            newUser.setValue(usrInfo.userEmail, forKey: UserCoreDatakeys.userEmail.rawValue)
            newUser.setValue(usrInfo.userId, forKey: UserCoreDatakeys.userId.rawValue)
            newUser.setValue(usrInfo.userImageUrl, forKey: UserCoreDatakeys.userImageUrl.rawValue)
            newUser.setValue(usrInfo.userName, forKey: UserCoreDatakeys.userName.rawValue)
            newUser.setValue(usrInfo.passWord, forKey: UserCoreDatakeys.password.rawValue)
            do {
                try context.save()
                print("User Data saved successfully!")
            } catch {
                print("Failed to save user: \(error)")
            }
        }
    }
    
    func updateUserDetails(usrInfo: UserModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDetailTable")
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = .dictionaryResultType
        let userIdPredicate = NSPredicate(format: "userId == %@", usrInfo.userId)
        fetchRequest.predicate = userIdPredicate
        do {
            if let users = try managedContext?.fetch(fetchRequest), let user = users.first {
                user.setValue(usrInfo.accessToken, forKey: UserCoreDatakeys.accessToken.rawValue)
                user.setValue(usrInfo.refreshToken, forKey: UserCoreDatakeys.accessToken.rawValue)
                user.setValue(usrInfo.tokenExpiry, forKey: UserCoreDatakeys.tokenExpiry.rawValue)
                user.setValue(usrInfo.userEmail, forKey: UserCoreDatakeys.userEmail.rawValue)
                user.setValue(usrInfo.userId, forKey: UserCoreDatakeys.userId.rawValue)
                user.setValue(usrInfo.userImageUrl, forKey: UserCoreDatakeys.userImageUrl.rawValue)
                user.setValue(usrInfo.userName, forKey: UserCoreDatakeys.userName.rawValue)
                user.setValue(usrInfo.passWord, forKey: UserCoreDatakeys.password.rawValue)
            }
            try managedContext?.save()
            print("User updated successfully!")
        } catch {
            print("Failed to update user: \(error)")
        }
    }
}
