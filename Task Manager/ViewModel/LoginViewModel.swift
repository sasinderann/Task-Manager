//
//  LoginViewModel.swift
//  Task Manager
//
//  Created by SASINDERAN N on 28/11/24.
//

import Foundation
import GoogleSignIn

class LoginViewModel {
    
    static let shared = LoginViewModel()
    
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
            "client_id": "123",
            "grant_type": "refresh_token"]
        
        let googleTokenUrl = "https://oauth2.googleapis.com/token"
        let url = URL(string: googleTokenUrl)!
        let request = NSMutableURLRequest(url: url)
        request.httpBody = userDict
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let dataTAsk = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error  in
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
}
