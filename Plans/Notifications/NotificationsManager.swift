//
//  NotificationsManager.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let instance = NotificationManager()
    
    override init() {
        super.init()
        self.requestAuthorization()
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.badge,.alert]) { succes, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            UNUserNotificationCenter.current().delegate = self
        }
    }
    
    func scheduleNotification(time:Double,exersiceName:String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Timer finished"
        content.body = "The timer for \(exersiceName) has finished"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelDeliveredNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func cancelScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.banner])
    }
}


