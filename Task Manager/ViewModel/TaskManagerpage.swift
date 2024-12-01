//
//  TaskManagerpage.swift
//  Task Manager
//
//  Created by SASINDERAN N on 01/12/24.
//

import Foundation

class TaskManagerViewModel {
    
    static let shared = TaskManagerViewModel(dataModel: TaskDataManager())
    var delegate : TaskDataManager?
    
    init(dataModel: TaskDataManager) {
         self.delegate = dataModel
     }
    
}
