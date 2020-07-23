//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Prabhdeep Singh on 22/07/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskTimePicker: UIDatePicker!
    var delegate: TaskProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameTextField.becomeFirstResponder()
        taskTimePicker.timeZone = TimeZone.current
       // taskTimePicker.
        
    }
    
    
    //MARK: Actions
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        guard let name = taskNameTextField.text else {
            //TODO: show alert here
            print("Please enter Task name")
            return
        }
        let taskDate = taskTimePicker.date
        let taskModel = TaskModel(taskDate: taskDate, taskName: name)
        let taskViewModel = TaskViewModel(task: taskModel)
        delegate?.retrieveTask(task: taskViewModel)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
    }
    

}

extension AddTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
