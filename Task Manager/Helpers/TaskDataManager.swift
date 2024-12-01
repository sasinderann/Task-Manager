//
//  TaskDataManager.swift
//  Task Manager
//
//  Created by SASINDERAN N on 30/11/24.
//

import Foundation
import CoreData

protocol TaskDataManagerProtocol: CoreDataSetupProtocol {
    func getAllTasksForUser(userId: Int64) -> [TaskModel]
    func createTaskForUser(task: TaskModel)
    func updateTaskForUser(userId: Int64, taskId: Int64, taskDetail: TaskModel)
}

class TaskDataManager: TaskDataManagerProtocol {
    
    func getAllTasksForUser(userId: Int64) -> [TaskModel] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskDetailsTable")
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = .dictionaryResultType
        let userIdPredicate = NSPredicate(format: "userId == %@", userId)
        fetchRequest.predicate = userIdPredicate
        
        do {
            if let tasks = try managedContext?.fetch(fetchRequest) as? [[String:Any]] {
                return TaskModel.decodeCoreDataKeys(coreDataJson: tasks)
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    func createTaskForUser(task: TaskModel) {
        if let context = managedContext, let entity = NSEntityDescription.entity(forEntityName: "TaskDetailsTable", in: context) {
            let newTask = NSManagedObject(entity: entity, insertInto: context)
            newTask.setValue(task.alarmReminderTime, forKey: TaskDetailsCoreDataKeys.alarmReminderTime.rawValue)
            newTask.setValue(task.date, forKey: TaskDetailsCoreDataKeys.date.rawValue)
            newTask.setValue(task.isCompleted, forKey: TaskDetailsCoreDataKeys.isCompleted.rawValue)
            newTask.setValue(task.priority, forKey: TaskDetailsCoreDataKeys.priority.rawValue)
            newTask.setValue(task.taskDescription, forKey: TaskDetailsCoreDataKeys.taskDescription.rawValue)
            newTask.setValue(task.taskName, forKey: TaskDetailsCoreDataKeys.taskName.rawValue)
            newTask.setValue(task.userId, forKey: TaskDetailsCoreDataKeys.userId.rawValue)
            newTask.setValue(task.taskId, forKey: TaskDetailsCoreDataKeys.taskId.rawValue)
            do {
                try context.save()
                print("User Data saved successfully!")
            } catch {
                print("Failed to save user: \(error)")
            }
        }
    }
    
    func updateTaskForUser(userId: Int64, taskId: Int64, taskDetail: TaskModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TaskDetailsTable")
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = .dictionaryResultType
        let userIdPredicate = NSPredicate(format: "userId == %@", userId)
        let taskPredicate = NSPredicate(format: "taskId == %@", taskId)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userIdPredicate, taskPredicate])
        do {
            if let storedTasks = try managedContext?.fetch(fetchRequest), let task = storedTasks.first {
                task.setValue(taskDetail.alarmReminderTime, forKey: TaskDetailsCoreDataKeys.alarmReminderTime.rawValue)
                task.setValue(taskDetail.date, forKey: TaskDetailsCoreDataKeys.date.rawValue)
                task.setValue(taskDetail.isCompleted, forKey: TaskDetailsCoreDataKeys.isCompleted.rawValue)
                task.setValue(taskDetail.priority, forKey: TaskDetailsCoreDataKeys.priority.rawValue)
                task.setValue(taskDetail.taskDescription, forKey: TaskDetailsCoreDataKeys.taskDescription.rawValue)
                task.setValue(taskDetail.taskName, forKey: TaskDetailsCoreDataKeys.taskName.rawValue)
                task.setValue(taskDetail.userId, forKey: TaskDetailsCoreDataKeys.userId.rawValue)
                task.setValue(taskDetail.taskId, forKey: TaskDetailsCoreDataKeys.taskId.rawValue)
            }
            try managedContext?.save()
            print("User updated successfully!")
        } catch {
            print("Failed to update user: \(error)")
        }
    }
    
}
