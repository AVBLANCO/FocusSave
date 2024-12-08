//
//  ProfileView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 6/11/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var notificationManager = NotificationManager()
    @ObservedObject var screenTimeManager = ScreenTimeManager()

    var body: some View {
        VStack {
            Button("Request Notification Permissions") {
                notificationManager.requestNotificationPermissions()
            }
            Button("Request Screen Time Permissions") {
                screenTimeManager.requestScreenTimePermissions()
            }
            List(notificationManager.notifications) { notification in
                Text(notification.identifier)
            }
            List(screenTimeManager.screenTimeData) { data in
                Text(data.description)
            }
        }
        .navigationTitle("Profiles")
    }
}

extension UNNotificationRequest: Identifiable {
    public var id: String {
        return identifier
    }
}
