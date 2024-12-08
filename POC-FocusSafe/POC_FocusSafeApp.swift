//
//  POC_FocusSafeApp.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 25/10/24.
//

import SwiftUI

@available(iOS 17.0, *)
@main
struct POC_FocusSafeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    requestNotificationPermissions()
                }
        }
    }

    func requestNotificationPermissions() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Error requesting notification permissions: \(error)")
                } else {
                    print("Notification permissions granted: \(granted)")
                }
            }
        }
}
