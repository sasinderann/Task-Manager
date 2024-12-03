//
//  TaskManagerPage.swift
//  Task Manager
//
//  Created by SASINDERAN N on 01/12/24.
//

import Foundation
import UIKit

class TaskManagerPage : UIViewController {
    @IBOutlet var outerView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var createTaskBtn: UIView!
    
    let viewModel = TaskManagerViewModel(dataModel: TaskDataManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        createTaskBtn.layer.cornerRadius = 8
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createTaskBtnClicked))
        createTaskBtn.addGestureRecognizer(tapGesture)
        // Register TBl cells
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(TaskViewCell.self, forCellReuseIdentifier: "taskCell")
        tblView.register(UserViewCell.self, forCellReuseIdentifier: "userCell")
        tblView.register(SortViewCell.self, forCellReuseIdentifier: "sortCell")
    }
    
    @objc  func createTaskBtnClicked() {
        if let taskCreationPage = self.storyboard?.instantiateViewController(withIdentifier: "newTaskCreationPage") as? NewTaskCreationPage {
            self.navigationController?.present(taskCreationPage, animated: true)
        }
    }
}

extension TaskManagerPage : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? viewModel.allTasks.count : 1
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // 0 -- UserInfo // 1 -- sorting // 2 -- tasks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserViewCell {
                if let currentUser = viewModel.delegate?.getCurrentUser() {
                    cell.loadTableData(userImg: currentUser.userImageUrl, name: currentUser.userName, email: currentUser.userEmail, completed: 100, inProgress: 100)
                }
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath) as? SortViewCell {
                cell.sortBy = .dateAdded
                cell.sortBtnClicked()
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskViewCell {
                let task = viewModel.allTasks[indexPath.row]
                cell.setTaskDetails(name: task.taskName, date: task.date, priorityLvl: task.priority, isAlarmEnable: task.alarmReminderTime != 0)
                return cell
            }
        }
        return UITableViewCell()
    }
}
