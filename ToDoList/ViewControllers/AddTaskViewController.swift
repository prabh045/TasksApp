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
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var taskTimePicker: UIDatePicker!
    var delegate: TaskProtocol?
    

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameTextField.becomeFirstResponder()
        taskDatePicker.timeZone = TimeZone.current
        taskTimePicker.timeZone = TimeZone.current
        taskDatePicker.minimumDate = Date.init()
        
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
        let taskDate = taskDatePicker.date
        print("Uncorrected Date",taskDate)
        let correctedDate = Date(timeInterval: TimeInterval(exactly: (23400-3600))!, since: taskDate)
        print("Corrected Date",correctedDate)
        
        let timeDate = taskTimePicker.date
        let taskTime = getTime(from: timeDate)
        
        //settimg up models and savind data
        let taskModel = TaskModel(taskDate: correctedDate, taskName: name)
        let taskViewModel = TaskViewModel(task: taskModel, taskTime: taskTime)
        delegate?.retrieveTask(task: taskViewModel)
        if CoreDataService.saveTask(taskViewModel) {
            NotificationService.getNotificationSettings(task: taskViewModel)
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
    }
    
    //Private Methods
    private func getTime(from date: Date) ->(Int,Int) {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
    
        print("Time is \(hour) : \(minute)")
        return (hour ?? 00,minute ?? 00)
    }
    

}

extension AddTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
