//
//  Alert.swift
//  ToDoList
//
//  Created by Prabhdeep Singh on 31/07/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import UIKit

class Alert {
    
    static func showAlert(title: String, message: String, presentingVc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        presentingVc.present(alert, animated: true, completion: nil)
        //return alert
    }
    
    static func showNotificationSettingAlert(_ presentingVc: UIViewController) {
        let alert = UIAlertController(title: "Notification Access Denied", message: "Please Give Access", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { _ in
            UIApplication.shared.open(URL(string: String(UIApplication.openSettingsURLString))!, options: [:], completionHandler: nil)
        }
        alert.addAction(ok)
        alert.addAction(settings)
        DispatchQueue.main.async {
            presentingVc.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
