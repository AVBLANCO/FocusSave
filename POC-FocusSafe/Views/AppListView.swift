//
//  AppListView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 8/11/24.
//

import SwiftUI

struct AppListView: View {
    @State private var appsInfo: [AppInfo] = []

    var body: some View {
        List(appsInfo) { app in
            HStack {
                Text(app.bundleIdentifier)
                Spacer()
                Text(app.isSuspended ? "Suspendido" : "En ejecución")
            }
        }
//        .onAppear {
//            if let timerViewController = UIApplication.shared.windows.first?.rootViewController as? TimerViewController {
//                appsInfo = timerViewController.getRunningApplications()
//            }
//        }

//        .onAppear {
//            // ...
//            let notificationName = Notification.Name("FocusModeStateChanged")
//            NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: .main) { notification in
//                if let userInfo = notification.userInfo, let isFocusModeActive = userInfo["isFocusModeActive"] as? Bool {
//                    self.isFocusModeActive = isFocusModeActive
//                }
//            }
//        }
    }
}
