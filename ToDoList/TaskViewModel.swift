//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Prabhdeep Singh on 23/07/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import Foundation

//Task of viewViewModel is to provide the VC/Views with displayable info like date string
class TaskViewModel {
    
    private var task: TaskModel
    
    var taskName: String {
        return self.task.taskName
    }
    var taskDate: String {
        return dateFormatter(date: task.taskDate)
    }
    var isCompleted: Bool {
        return self.task.isCompleted
    }
    
    init(task: TaskModel) {
        self.task = task
    }
    
    private func dateFormatter(date: Date) -> String{
        // subtracted 6.5 hours to make it IST
        var correctedDate = date
        correctedDate = Date(timeInterval: TimeInterval(exactly: -23400)!, since: date)

        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "dd MMMM YYYY"
        print(correctedDate)
        return dateFormmater.string(from: correctedDate)
    }
    
    func fetchData() {
        //CoreDataService
    }
    
}
