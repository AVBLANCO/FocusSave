//
//  ScreenTimeManager.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 6/11/24.
//

import Foundation
import FamilyControls
import DeviceActivity

// TODO: ajustes
import Foundation
import FamilyControls
import DeviceActivity

class ScreenTimeManager: ObservableObject {
    let deviceActivityCenter = DeviceActivityCenter()

    @Published var screenTimeData: [ScreenTimeData] = [
        ScreenTimeData(description: "com.facebook.Facebook"),
        ScreenTimeData(description: "com.google.chrome.ios"),
        ScreenTimeData(description: "com.burbn.instagram"),
        ScreenTimeData(description: "com.zhiliaoapp.musically"),
        ScreenTimeData(description: "com.atebits.Tweetie2")
    ]

    @Published var selectedApps: Set<String> = []
   // private var monitor: DeviceActivityName = DeviceActivityName("com.example.ScreenTimeMonitor")
    private var monitor: DeviceActivityName = DeviceActivityName("personal.POC-FocusSafe")

    func requestScreenTimePermissions() {
        AuthorizationCenter.shared.requestAuthorization { result in
            switch result {
            case .success:
                print("Authorization granted.")
                self.setupDeviceActivityMonitor()
            case .failure(let error):
                print("Authorization failed: \(error.localizedDescription)")
                // Reintentar después de un tiempo
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.requestScreenTimePermissions()
                }
            }
        }
    }

    func restrictAppUsage(appIdentifiers: [String], restricted: Bool) {
        if restricted {
            selectedApps.formUnion(appIdentifiers)
        } else {
            selectedApps.subtract(appIdentifiers)
        }
        setupDeviceActivityMonitor()
    }

    func toggleAppSelection(_ app: ScreenTimeData) {
        if selectedApps.contains(app.description) {
            selectedApps.remove(app.description)
        } else {
            selectedApps.insert(app.description)
        }
    }

    private func setupDeviceActivityMonitor() {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 8),
            intervalEnd: DateComponents(hour: 22),
            repeats: true
        )

        do {
            try deviceActivityCenter.startMonitoring(monitor, during: schedule)
            print("Monitoreo de actividades de dispositivo iniciado.")
        } catch {
            print("Error al iniciar el monitoreo: \(error.localizedDescription)")
        }
    }
}
//
//
//// TODO: Primera Implementacion:
//class ScreenTimeManager: ObservableObject {
//    let deviceActivityCenter = DeviceActivityCenter()
//
//    @Published var screenTimeData: [ScreenTimeData] = [
//        ScreenTimeData(description: "com.facebook.Facebook"),
//        ScreenTimeData(description: "com.google.chrome.ios"),
//        ScreenTimeData(description: "com.burbn.instagram"),
//        ScreenTimeData(description: "com.zhiliaoapp.musically"),
//        ScreenTimeData(description: "com.atebits.Tweetie2")
//    ]
//
//    @Published var selectedApps: Set<String> = []
//    private var monitor: DeviceActivityName = DeviceActivityName("com.example.ScreenTimeMonitor")
//
//    func requestScreenTimePermissions() {
//        AuthorizationCenter.shared.requestAuthorization { result in
//            switch result {
//            case .success:
//                print("Authorization granted.")
//                self.setupDeviceActivityMonitor()
//            case .failure(let error):
//                print("Authorization failed: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func restrictAppUsage(appIdentifiers: [String], restricted: Bool) {
//        if restricted {
//            selectedApps.formUnion(appIdentifiers)
//        } else {
//            selectedApps.subtract(appIdentifiers)
//        }
//        setupDeviceActivityMonitor()
//    }
//
//    func toggleAppSelection(_ app: ScreenTimeData) {
//        if selectedApps.contains(app.description) {
//            selectedApps.remove(app.description)
//        } else {
//            selectedApps.insert(app.description)
//        }
//    }
//
//    private func setupDeviceActivityMonitor() {
//        let schedule = DeviceActivitySchedule(
//            intervalStart: DateComponents(hour: 8),
//            intervalEnd: DateComponents(hour: 22),
//            repeats: true
//        )
//
//        do {
//            try deviceActivityCenter.startMonitoring(monitor, during: schedule)
//            print("Monitoreo de actividades de dispositivo iniciado.")
//        } catch {
//            print("Error al iniciar el monitoreo: \(error.localizedDescription)")
//        }
//    }
//}
