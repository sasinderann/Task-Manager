//
//  UserViewCell.swift
//  Task Manager
//
//  Created by SASINDERAN N on 01/12/24.
//

import UIKit

class UserViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailId: UILabel!
    @IBOutlet weak var taskStackView: UIStackView!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var inProgressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadTableData(userImg: String, name: String, email: String, completed: Int, inProgress: Int) {
        if let url = URL(string: userImg), let data = try? Data(contentsOf: url) {
            userImage.image = UIImage(data: data)
        }
        userName.text = name
        emailId.text = email
        completedLbl.text = "Completed: \(completed)"
        inProgressLbl.text = "In-progress: \(inProgress)"
    }
    
}
