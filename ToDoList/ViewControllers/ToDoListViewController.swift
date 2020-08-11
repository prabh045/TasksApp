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
    var filteredTasks = [TaskViewModel]()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "~~To Do List~~"
        NotificationService.askForNotificationPermission(self)
        setupSearchController()
        DispatchQueue.main.async {
            self.toDoList = TaskViewModel.fetchData()
            self.toDoListTableView.reloadData()
        }
        
    }
    
    //Mark: Setup search Controller
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    //MARK: Tableview DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredTasks.count : toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell else {
            fatalError("No Matching cell found")
        }
        
        let task = isFiltering ? filteredTasks[indexPath.row] : toDoList[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = isFiltering ? filteredTasks[indexPath.row] : toDoList[indexPath.row]
//        let alert = Alert.showAlert(title: task.taskName, message: "I have to complete this task.")
//        self.present(alert, animated: true, completion: nil)
        
        Alert.showAlert(title: task.taskName, message: "Complete this", presentingVc: self)
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
    
    //MARK: Search Tasks
    func filterContentForearchText(_ searchText: String) {
        filteredTasks = toDoList.filter({ (task: TaskViewModel) -> Bool in
            return task.taskName.lowercased().contains(searchText.lowercased())
        })
        toDoListTableView.reloadData()
    }
    

}

extension ToDoListViewController: TaskProtocol {
    
    func retrieveTask(task: TaskViewModel) {
        self.toDoList.append(task)
        self.toDoListTableView.reloadData()
    }
    
    
    
}

extension ToDoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForearchText(searchBar.text ?? "")
    }
    
    
}

