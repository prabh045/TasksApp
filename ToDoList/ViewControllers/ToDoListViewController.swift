//
//  ViewController.swift
//  ToDoList
//
//  Created by Prabhdeep Singh on 22/07/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import UIKit
import os.log

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var toDoListTableView: UITableView!
    var toDoList = [TaskViewModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "~~To Do List~~"
        DispatchQueue.main.async {
            self.toDoList = TaskViewModel.fetchData()
            self.toDoListTableView.reloadData()
        }
        
    }
    
    //MARK: Tableview DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell else {
            fatalError("No Matching cell found")
        }
        let task = toDoList[indexPath.row]
        cell.taskNameLabel.text = task.taskName
        cell.taskDateLabel.text = "\(task.taskDate) at \(task.taskTime.0):\(task.taskTime.1)"
        
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            CoreDataService.deleteTask(at: indexPath) {
                self.toDoList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: Actions
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addTask", sender: nil)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nvc = segue.destination as? UINavigationController {
            if let vc = nvc.topViewController as? AddTaskViewController {
                vc.delegate = self
            }
        }
    }
    

}

extension ToDoListViewController: TaskProtocol {
    
    func retrieveTask(task: TaskViewModel) {
        self.toDoList.append(task)
        self.toDoListTableView.reloadData()
    }
    
    
    
}

