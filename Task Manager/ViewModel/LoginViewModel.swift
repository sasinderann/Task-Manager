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
    
    func signInWithGoogleServices(viewController: ViewController, getCompleted: @escaping(_ done: Bool) -> ()) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
           guard error == nil else { return }

           // If sign in succeeded, display the app's main content View.
         }
    }
}
