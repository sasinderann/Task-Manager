//
//  LoginPage.swift
//  Task Manager
//
//  Created by SASINDERAN N on 28/11/24.
//

import Foundation
import UIKit
import GoogleSignIn

class LoginPage : UIViewController {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
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
    }
    
    @IBAction func signBtnClicked(_ sender: Any) {
    }
    
}
