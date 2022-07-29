//
//  NotificationHandler.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 28/07/22.
//

import Foundation
import UserNotifications

struct NotificationHandler {
    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func addNotification(title: String, subtitle: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        // show this notification five seconds from now
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    static func deleteNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requests.map { $0.identifier })
        })
        
    }
}
