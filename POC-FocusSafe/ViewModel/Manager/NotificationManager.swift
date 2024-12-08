//
//  NotificationManager.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 6/11/24.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var notifications: [UNNotificationRequest] = []

    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.scheduleNotifications()
            } else {
                // Handle permission denied
            }
        }
    }

    func scheduleNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "Restricted App Usage"
        content.body = "You have reached your daily limit for this app."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
