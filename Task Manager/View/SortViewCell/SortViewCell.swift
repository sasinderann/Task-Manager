//
//  SortViewCell.swift
//  Task Manager
//
//  Created by SASINDERAN N on 01/12/24.
//

import UIKit

protocol SortTaskDelegate {
    func sortTaskData(type: SortType)
}

class SortViewCell: UITableViewCell, Identifiable {

    @IBOutlet weak var sortLbl: UILabel!
    @IBOutlet weak var sortIcon: UIImageView!
    
    var sortBy : SortType = .dateAdded
    var delegate : SortTaskDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sortBtnClicked))
        sortIcon.addGestureRecognizer(tapGesture)
    }
    
    @objc func sortBtnClicked() {
        sortBy = sortBy == .priority ? .dateAdded : .priority
        sortLbl.text = sortBy.rawValue
        delegate?.sortTaskData(type: sortBy)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
