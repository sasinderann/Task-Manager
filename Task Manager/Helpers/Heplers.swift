//
//  Heplers.swift
//  Task Manager
//
//  Created by SASINDERAN N on 30/11/24.
//

import Foundation
import UIKit

enum TaskDetailsCoreDataKeys: String {
 case taskName, taskDescription, date, priority, alarmReminderTime, isCompleted, userId, taskId
}

enum UserCoreDatakeys: String {
   case userName, userId, userEmail, password, accessToken, tokenExpiry, refreshToken, userImageUrl
}

extension String {
    
    func checkForValidPassword() -> Bool {
        let passwordRegex = "^.{8,}$"
           return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}

extension UIViewController {
    
    func showToast(message:String, type: ToastType) {
        DispatchQueue.main.async {
            let toastLbl = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height - 100, width: self.view.frame.width - 40 , height: 30))
            toastLbl.layer.cornerRadius = 8;
            toastLbl.clipsToBounds  =  true
            toastLbl.textColor = .white
            toastLbl.font = .systemFont(ofSize: 15)
            toastLbl.textAlignment = .center;
            toastLbl.text = message
            self.view.addSubview(toastLbl)
            toastLbl.backgroundColor = type.color
            UIView.animate(withDuration: 2.0, delay: 0, options: .transitionCurlDown, animations: {
            }, completion: {(isCompleted) in
                toastLbl.removeFromSuperview()
            })
        }
    }
    
    func getRootViewController() -> UIViewController {
        if #available(iOS 13, *) {
            let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
            return (scene?
                .windows.first(where: { $0.isKeyWindow })?
                .rootViewController)!
        } else {
            return (UIApplication.shared.keyWindow?.rootViewController)!
        }
    }
}

enum ToastType {
    case Success
    case Error
    case Warning
    
    var color : UIColor {
        switch self {
        case .Success:
            return UIColor.systemGreen
        case .Error:
            return UIColor.systemRed
        case .Warning:
            return UIColor.systemYellow
        }
    }
}


enum SortType: String{
    case priority = "Priority"
    case dateAdded = "Date Added"
}
