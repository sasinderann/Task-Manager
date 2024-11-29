//
//  TaskModel.swift
//  Task Manager
//
//  Created by SASINDERAN N on 29/11/24.
//

import Foundation

struct TaskModel: Codable {
    var taskName: String = ""
    var taskDescription: String = ""
    var date: Date = Date()
    var priority: Int = 1 // 1- normal, 2 - high , 3 - high
    var alarmReminderTime: Int = 0
    var isCompleted: Bool = false
    var userId: Int64 = 0
    
    static func decodeCoreDataKeys(coreDataJson: [[String:Any]]) -> [TaskModel] {
        var taskItems : [TaskModel] = []
        
        for dict in coreDataJson {
            var taskItem = TaskModel()
            if let name = dict[TaskDetailsCoreDataKeys.taskName.rawValue] as? String {
                taskItem.taskName = name
            }
            if let taskDescription = dict[TaskDetailsCoreDataKeys.taskDescription.rawValue] as? String {
                taskItem.taskDescription = taskDescription
            }
            if let date = dict[TaskDetailsCoreDataKeys.date.rawValue] as? Date {
                taskItem.date = date
            }
            if let priority = dict[TaskDetailsCoreDataKeys.priority.rawValue] as? Int {
                taskItem.priority = priority
            }
            if let alarmReminderTime = dict[TaskDetailsCoreDataKeys.alarmReminderTime.rawValue] as? Int {
                taskItem.alarmReminderTime = alarmReminderTime
            }
            if let isCompleted = dict[TaskDetailsCoreDataKeys.isCompleted.rawValue] as? Bool {
                taskItem.isCompleted = isCompleted
            }
            if let userId = dict[TaskDetailsCoreDataKeys.userId.rawValue] as? Int64 {
                taskItem.userId = userId
            }
            taskItems.append(taskItem)
        }
        return taskItems
    }
}

// In case if hosted in server use json serialization
func jsonParseDecoder(json: [[String:Any]]) -> [TaskModel] {
    do {
        let data = try JSONSerialization.data(withJSONObject: json)
        return try JSONDecoder().decode([TaskModel].self, from: data)
    } catch {
        return []
    }
}

