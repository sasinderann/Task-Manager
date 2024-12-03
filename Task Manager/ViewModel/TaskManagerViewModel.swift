//
//  TaskManagerpage.swift
//  Task Manager
//
//  Created by SASINDERAN N on 01/12/24.
//

import Foundation

class TaskManagerViewModel {
    
    var delegate : TaskDataManager?
    var allTasks = [TaskModel]()
    
    init(dataModel: TaskDataManager) {
        self.delegate = dataModel
        getAllTasks()
    }
    
    func getAllTasks() {
        allTasks = delegate?.getAllTasksForUser(userId: UserDefault.currentAccountId) ?? []
    }
}
