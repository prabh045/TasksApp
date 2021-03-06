//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Prabhdeep Singh on 23/07/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import UIKit
import CoreData
import os.log

class CoreDataService {
    
    static private var fetchedManagedObjects = [NSManagedObject]()
    
    static func saveTask(_ task: TaskViewModel) -> Bool{
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No app delegate")
        }
        
        let managedContext = appdelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
        print("Task Date is \(task.date)")
        managedObject.setValue(task.taskName, forKey: "name")
        managedObject.setValue(task.date, forKey: "date")
        managedObject.setValue(task.isCompleted, forKey: "isCompleted")
        managedObject.setValue(task.taskTime.0, forKey: "taskHour")
        managedObject.setValue(task.taskTime.1, forKey: "taskMinute")
        
        do {
            try managedContext.save()
            os_log("Task Saved")
            return true
        } catch {
            os_log("Error saving Task")
            return false
        }
        
    }
    
    static func retrieveTasks() -> [NSManagedObject] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("no app delegate found")
        }
        
        let managedcontext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Task")
        
        do {
            let tasks = try managedcontext.fetch(fetchRequest)
            os_log("Tasks fetched successfully", [tasks])
            fetchedManagedObjects = tasks
            return tasks
        } catch  {
            os_log("Could not fetch tasks")
            return []
        }
    }
    
    static func deleteTask(at indexPath: IndexPath,completionHandler: @escaping () -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("no app delegate found")
        }
        
        let managedcontext = appDelegate.persistentContainer.viewContext
        let objectToDelete = fetchedManagedObjects[indexPath.row]
        managedcontext.delete(objectToDelete)
        do {
            try managedcontext.save()
        } catch {
            os_log("Error in saving data after deleting")
        }
        completionHandler()
    }
}
