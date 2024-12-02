//
//  NewTaskCreationPage.swift
//  Task Manager
//
//  Created by SASINDERAN N on 02/12/24.
//

import Foundation
import UIKit

class NewTaskCreationPage : UIViewController {
    
    @IBOutlet var outerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priorityStack: UIStackView!
    @IBOutlet weak var alarmStack: UIStackView!
    @IBOutlet weak var saveBtn: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
