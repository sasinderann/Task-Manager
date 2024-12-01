//
//  LoginPage.swift
//  Task Manager
//
//  Created by SASINDERAN N on 28/11/24.
//

import Foundation
import UIKit
import GoogleSignIn
import GoogleSignInSwift

class LoginPage : UIViewController {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var googleSignInButtonView: GIDSignInButton!
    
    var viewModel : LoginViewModel = LoginViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        userNameField.layer.borderWidth = 1
        userNameField.layer.borderColor = UIColor.lightGray.cgColor
        userNameField.layer.cornerRadius = 6
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.layer.cornerRadius = 6
        let gesture = UITapGestureRecognizer(target: self, action: #selector(signInWithGoogle))
        googleSignInButtonView.addGestureRecognizer(gesture)
    }
    
    @IBAction func signBtnClicked(_ sender: Any) {
        if let userName = userNameField.text, let password = passwordField.text {
            if viewModel.validateUser(userName: userName, password: password) {
                print("--- Login Success ---")
                DispatchQueue.main.async {
                    if self.navigationController == nil {
                        print("Navigation Controller is nil")
                    } else {
                        print("Navigation Controller is present")
                    }
                    if let taskManagerPage = self.storyboard?.instantiateViewController(withIdentifier: "taskManagerId") as? TaskManagerPage {
                        print("Page ")
                        self.navigationController?.pushViewController(taskManagerPage, animated: true)
                    }
                }
            }
        } else {
            self.showToast(message: "Incorrect username or password", type: .Warning)
        }
        print("---Clicked---r")
    }
    
    @objc func signInWithGoogle() {
        viewModel.signInWithGoogleServices(viewController: self) { done, userDetails in
            if done {
                var userInfo = userDetails
                let userName = userInfo?.userName ?? userInfo?.userEmail ?? "Default"
                self.promptForUserPassword(user: userName) { hasVerified, password in
                    userInfo?.passWord = password
                    self.viewModel.saveUserInfo(userData: userInfo)
                }
            }
        }
    }
    
    func promptForUserPassword(user: String, showPasswordFailed: Bool = false, passwordVerified: @escaping(_ done: Bool, _ password: String) -> ()) {
        let alertController = UIAlertController(title: "Set Password", message: "Enter password for '\(user)'", preferredStyle: .alert)
        alertController.addTextField { (userFieild) in
            userFieild.text = user
            userFieild.isUserInteractionEnabled = false
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Set your password"
            textField.isSecureTextEntry = true
        }
        
        if showPasswordFailed {
            let label = UILabel()
            label.text = "password should have atleast 8 chars"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.numberOfLines = 0
            label.textColor = .systemRed
            alertController.view.addSubview(label)
            label.frame = CGRect(x: 0, y: 50, width: 270, height: 40)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            return passwordVerified(false,"")
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let password = alertController.textFields![1].text, password.checkForValidPassword() {
                return passwordVerified(true, password)
            } else {   
                return self.promptForUserPassword(user: user,showPasswordFailed: true, passwordVerified: passwordVerified)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
}
