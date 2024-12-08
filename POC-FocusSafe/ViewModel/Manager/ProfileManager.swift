//
//  ProfileManager.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 6/11/24.
//

import Foundation
//import DeviceManagement
import UserNotifications
import ManagedSettings

class ProfileManager: ObservableObject {
    @Published var profiles: [Profile] = []

    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            } else {
                print("Notification permissions granted: \(granted)")
            }
        }
    }

    func configureScreenTimeLimits() {
        // Implementa la configuración de Screen Time y ManagedSettings aquí.
        // Ejemplo: Define restricciones o límites para ciertas aplicaciones.
    }

    func fetchProfiles() {
        // Implementa la lógica para obtener perfiles de uso, basándote en la configuración que hayas aplicado.
    }

    /**
     Otra implementacion :  Control Parental y Monitoreo Externo con Notificaciones Push
     */

    func schedulePushNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Activar App Focus Safe"
        content.body = "Tu sesión de enfoque ha comenzado."

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "focusSafe", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error al programar notificación: \(error)")
            }
        }
    }
}
