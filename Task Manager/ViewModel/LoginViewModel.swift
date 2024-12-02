//
//  LoginViewModel.swift
//  Task Manager
//
//  Created by SASINDERAN N on 28/11/24.
//

import Foundation
import GoogleSignIn

class LoginViewModel {
    fileprivate var clientId = "880624567821-rissjt2bh6os7lcil2c9ogtjneso2dku.apps.googleusercontent.com"
    static let shared = LoginViewModel(dataModel: UserDataManager())
    var delegate : UserDataProtocol?
    
    init(dataModel: UserDataProtocol) {
         self.delegate = dataModel
     }
    
    //    MARK: - Google Authentication
    func signInWithGoogleServices(viewController: UIViewController, getCompleted: @escaping(_ done: Bool, _ userInfo: UserModel?) -> ()) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController, hint: "", additionalScopes: ["https://www.googleapis.com/auth/userinfo.profile"]) { user, error in
            if let err = error {
                print("-- Error in logging google account \(err.localizedDescription) --")
                return getCompleted(false, nil)
            }
            
            var userDetail = UserModel()
            if let userInfo = user?.user {
                userDetail.accessToken = userInfo.accessToken.tokenString
                userDetail.userEmail = userInfo.profile?.email ?? ""
                userDetail.tokenExpiry = Date().addingTimeInterval(60*60) // Indefault token expiry is 60 mins
                userDetail.refreshToken = userInfo.refreshToken.tokenString
                userDetail.userId = Int64.random(in: 1..<123456789)
                userDetail.userName = userInfo.profile?.name ?? "Default user"
                if userInfo.profile?.hasImage ?? false {
                    userDetail.userImageUrl = userInfo.profile?.imageURL(withDimension: 100)?.absoluteString ?? ""
                }
            }
            getCompleted(true, userDetail)
        }
    }
    
    //    TODO: Add client id
    func silentTokenRefreshForAccount(userInfo: UserModel, isTokenRefreshed: @escaping(_ done: Bool, _ updatedInfo: UserModel) ->()) {
        let userDict : [String: Any] = [
            "access_token": userInfo.accessToken,
            "refresh_token": userInfo.refreshToken,
            "client_id": clientId,
            "grant_type": "refresh_token"]
        
        let googleTokenUrl = "https://oauth2.googleapis.com/token"
        let url = URL(string: googleTokenUrl)!
        let request = NSMutableURLRequest(url: url)
        request.httpBody = userDict
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
       URLSession.shared.dataTask(with: request as URLRequest) { data, response, error  in
            if let err = error {
                print("--- Error in refreshing google token : \(err.localizedDescription) ---")
                return isTokenRefreshed(false, userInfo)
            }
            guard let responseData = data else {
                print("--- Invalid response data ---")
                return isTokenRefreshed(false, userInfo)
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    var updatedUser = userInfo
                    updatedUser.accessToken = accessToken
                    isTokenRefreshed(true, updatedUser)
                } else {
                    return isTokenRefreshed(false, userInfo)
                }
            } catch {
                return isTokenRefreshed(false, userInfo)
            }
        }
    }
    
    func loggedOutUser() {
        GIDSignIn.sharedInstance.signOut()
    }
//    MARK: - DATA MANIPULATION DELEGATES
    
    func saveUserInfo(userData: UserModel?) {
        if let data = userData {
            delegate?.saveNewEntry(coreDataEntry: data)
        }
    }
    
    func updateUserInfo(userData: UserModel) {
        delegate?.updateUserDetails(usrInfo: userData)
    }
    
    func getUserDetails() -> [UserModel]? {
        return delegate?.getLoggedInUsers()
    }
    
    // check with google user name first then check with
    func validateUser(userName: String, password: String) -> (Bool, Int64) {
        if let user = getUserFor(userName: userName) {
            return (user.passWord == password, user.userId)
        }
        return (false, 0)
    }
    
    func getUserFor(userName: String) -> UserModel? {
        if let allUsers = getUserDetails() {
            if let usersDataInDB = (allUsers.filter({$0.userName == userName}).isEmpty ? allUsers.filter({$0.userName == userName}) : (allUsers.filter({$0.userName == userName}))).first {
                return usersDataInDB
            }
        }
        return nil
    }
    
}
