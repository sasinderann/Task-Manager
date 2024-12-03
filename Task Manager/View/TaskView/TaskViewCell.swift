//
//  TaskViewTableViewCell.swift
//  Task Manager
//
//  Created by SASINDERAN N on 28/11/24.
//

import UIKit


class TaskViewCell: UITableViewCell, Identifiable {
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var priority: UIButton!
    @IBOutlet weak var alarmEnable: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTaskDetails(name: String, date: Date, priorityLvl: Int, isAlarmEnable: Bool) {
        taskName.text = name
        taskDate.text = date.description
        
        if priorityLvl == 1 {
            priority.tintColor = UIColor.link
        } else if priorityLvl == 2 {
            priority.tintColor = UIColor.yellow
        } else if priorityLvl == 3 {
            priority.tintColor = .systemRed
        } else {
            priority.isHidden = true
        }
        alarmEnable.isHidden = isAlarmEnable
    }
}
