//
//  ViewController.swift
//  NotifyDemo
//
//  Created by DP Bhatt on 17/05/2018.
//  Copyright © 2018 AceMySkills. All rights reserved.
// Source:
// https://www.techotopia.com/index.php/An_iOS_10_Local_Notification_Tutorial

import UIKit
import UserNotifications

class ViewController: UIViewController , UNUserNotificationCenterDelegate{

    var messageSubtitle = "Staff Meeting in 20 minutes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UNUserNotificationCenter.current().requestAuthorization(options:
            [[.alert, .sound, . badge]], completionHandler: {(granted, error)  in
                
        })
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "repeat":
            self.sendNotification()
        case "change":
            let textResponse = response as! UNTextInputNotificationResponse
            messageSubtitle = textResponse.userText
            self.sendNotification()
        default:
            break;
        }
        completionHandler()
    }
    @IBAction func buttonPressed(_ sender: Any) {
        sendNotification()
    }
    
    func sendNotification()  {
        let content = UNMutableNotificationContent()
        content.title = "Meeting Reminder"
        content.subtitle = messageSubtitle
        content.body = "Don't forget to bring coffee."
        content.badge = 1
        
        let repeatAction = UNNotificationAction(identifier: "repeat", title: "Repeat", options: [])
        let changeAction = UNTextInputNotificationAction(identifier: "change", title: "Change Message", options: [])
        
        let category = UNNotificationCategory(identifier: "actionCategory", actions: [repeatAction, changeAction], intentIdentifiers: [], options: [.hiddenPreviewsShowTitle, .hiddenPreviewsShowSubtitle])
        
        content.categoryIdentifier = "actionCategory"
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let requestIdentifier = "demoNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
