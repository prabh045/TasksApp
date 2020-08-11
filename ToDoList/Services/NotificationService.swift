//
//  NotificationService.swift
//  ToDoList
//
//  Created by Prabhdeep Singh on 24/07/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import UIKit
import UserNotifications
import os.log

class NotificationService {
    
    static func getNotificationSettings(task: TaskViewModel) {
       
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            
            
            
            switch notificationSettings.authorizationStatus {
                
            case .notDetermined:
                os_log("Ask for persmission")
                
            case .authorized:
                //save local notification
                //or register for remote notification
                os_log("We have permsiion .do something now")
                scheduleNotification(for: task)
                
            case .denied:
                //display alert to open setting app
                //Alert.showNotificationSettingAlert()
                os_log("User dont want to be reminted of their tasks")
                
            default:
                os_log("Wth we doin")
            }
        }
    }
    
    
    static func askForNotificationPermission(_ vc: UIViewController) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (success, error) in
            if let error = error {
                os_log("Error in asking permission", [error])
                return
            }
            guard success else {
                Alert.showNotificationSettingAlert(vc)
                os_log("permission not granted")
                return
            }
          
            os_log("Permission granted")
            
        }
    }
    
    private static func scheduleNotification(for task: TaskViewModel) {
        //create notification content
        let notificationContent = UNMutableNotificationContent()
        
        //configure notification Content
        notificationContent.title = "Reminder!"
        notificationContent.body = "Its Time For Your Task!! Bruh \u{1F600}"
        notificationContent.subtitle = task.taskName
        
        //Add triger
        print("task date in notification \(task.date)")
        var dateComponents = Calendar.current.dateComponents(Set<Calendar.Component>(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day), from: task.date)
        print("date components date \(dateComponents.date)")
        dateComponents.day = dateComponents.day! - 1 
        dateComponents.hour = task.taskTime.0
        dateComponents.minute = task.taskTime.1
        
        print("Notification set for \(dateComponents)")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //create notification request
        let request = UNNotificationRequest(identifier: task.taskName, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                os_log("Error in Notification scheduling", [error.localizedDescription])
                return
            }
            os_log("Notification scheduled successfully")
        }
        
        
    }
    
}

