//
//  AppDelegate.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 12/11/24.
//

import Foundation
import UIKit
import BackgroundTasks

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isFocused = false

    func applicationWillTerminate(_ application: UIApplication) {
        if isFocused {
            // Reiniciar el temporizador o realizar otras acciones
            UserDefaults.standard.set(true, forKey: "wasInFocusMode")
            print("La aplicación se está cerrando mientras está en modo de enfoque.")
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if UserDefaults.standard.bool(forKey: "wasInFocusMode") {
            // Restablece el modo de enfoque o muestra una notificación
            print("La aplicación se abrió después de un cierre en modo de enfoque.")
            UserDefaults.standard.set(false, forKey: "wasInFocusMode")
            // Aquí puedes mostrar una notificación o abrir la vista de enfoque
        }
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // Implementación de la tarea en segundo plano
        print(" AppDelegate handleEventsForBackgroundURLSession")
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Implementación de la tarea en segundo plano
        completionHandler(.newData)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.app.refresh", using: nil) { task in
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "personal.POC-FocusSafe", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        return true
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        task.setTaskCompleted(success: true)
    }

    func application(_ application: UIApplication, handleEventsForBackgroundTasks taskIdentifier: String) {
        switch taskIdentifier {
        //case "com.example.app.refresh":
        case "personal.POC-FocusSafe":
            scheduleAppRefresh()
        default:
            break
        }
    }

    func scheduleAppRefresh() {
        // Implementación de la tarea en segundo plano
        print("App refresh task scheduled")
    }
}

//class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?
//    var isFocused = false
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        if isFocused {
//            // Reiniciar el temporizador o realizar otras acciones
//            print("La aplicación se está cerrando mientras está en modo de enfoque.")
//        }
//    }
//}
