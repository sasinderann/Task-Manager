//
//  Heplers.swift
//  Task Manager
//
//  Created by SASINDERAN N on 30/11/24.
//

import Foundation


enum TaskDetailsCoreDataKeys: String {
 case taskName, taskDescription, date, priority, alarmReminderTime, isCompleted, userId
}

enum UserCoreDatakeys: String {
   case userName, userId, userEmail, passWord, accessToken, tokenExpiry, refreshToken, userImageUrl
}
