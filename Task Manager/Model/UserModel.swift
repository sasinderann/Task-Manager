//
//  UserModel.swift
//  Task Manager
//
//  Created by SASINDERAN N on 29/11/24.
//

import Foundation

struct UserModel: Codable {
    var userName: String = ""
    var userId : Int64 = 0
    var userEmail : String = ""
    var passWord: String = ""
    var accessToken : String = ""
    var tokenExpiry: Date = Date()
    var refreshToken : String = ""
    var userImageUrl : String = ""
    
    static func decodeCoreDataJsonResponse(userJson: [[String:Any]]) -> [UserModel] {
        var loggedInUsers: [UserModel] = []
        
        for json in userJson {
            var userObj = UserModel()
            if let userName = json[UserCoreDatakeys.userName.rawValue] as? String {
                userObj.userName = userName
            }
            if let userId = json[UserCoreDatakeys.userId.rawValue] as? Int64 {
                userObj.userId = userId
            }
            if let userEmail = json[UserCoreDatakeys.userEmail.rawValue] as? String {
                userObj.userEmail = userEmail
            }
            if let passWord = json[UserCoreDatakeys.passWord.rawValue] as? String {
                userObj.passWord = passWord
            }
            if let accessToken = json[UserCoreDatakeys.accessToken.rawValue] as? String {
                userObj.accessToken = accessToken
            }
            if let tokenExpiry = json[UserCoreDatakeys.tokenExpiry.rawValue] as? Date {
                userObj.tokenExpiry = tokenExpiry
            }
            if let refreshToken = json[UserCoreDatakeys.refreshToken.rawValue] as? String {
                userObj.refreshToken = refreshToken
            }
            if let imageUrl = json[UserCoreDatakeys.userImageUrl.rawValue] as? String {
                userObj.userImageUrl = imageUrl
            }
            loggedInUsers.append(userObj)
        }
        return loggedInUsers
    }
    
//    Incase of server Parser added
    func decodeServeResponse(json: [[String: Any]]) -> [UserModel] {
        do {
            let data = try JSONSerialization.data(withJSONObject: json)
            return try JSONDecoder().decode([UserModel].self, from: data)
        } catch let err {
            print("--- Error in deocoding server parsing : \(err.localizedDescription)")
            return []
        }
    }
    
}
