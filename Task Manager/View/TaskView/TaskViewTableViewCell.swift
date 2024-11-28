//
//  TaskViewTableViewCell.swift
//  Task Manager
//
//  Created by SASINDERAN N on 28/11/24.
//

import UIKit

class TaskViewTableViewCell: UITableViewCell {
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
    
}
