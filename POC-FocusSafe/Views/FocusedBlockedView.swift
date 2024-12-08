////
////  FocusedBlockedView.swift
////  POC-FocusSave
////
////  Created by Victor Manuel Blanco Mancera on 12/11/24.
////
//
//import SwiftUI
//import UIKit
//import FamilyControls
//import Intents
//import UserNotifications
//import MobileCoreServices
//import ManagedSettings
//import DeviceActivity
//
//struct FocusedBlockedView: UIViewController {
//
//    var timeTextField: UITextField!
//    var startButton: UIButton!
//    var screenTimeManager = ScreenTimeManager()
//    var isFocused = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        requestScreenTimeAuthorization()
//        requestNotificationAuthorization()
//    }
//
//    func setupUI() {
//        view.backgroundColor = .white
//
//        timeTextField = UITextField()
//        timeTextField.placeholder = "Ingresa el tiempo (en segundos)"
//        timeTextField.borderStyle = .roundedRect
//        timeTextField.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(timeTextField)
//
//        startButton = UIButton(type: .system)
//        startButton.setTitle("Iniciar", for: .normal)
//        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
//        startButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(startButton)
//
//        NSLayoutConstraint.activate([
//            timeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            timeTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
//            timeTextField.widthAnchor.constraint(equalToConstant: 200),
//
//            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            startButton.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 20)
//        ])
//    }
//
//    @objc func startButtonTapped() {
//        guard let timeString = timeTextField.text, !timeString.isEmpty else {
//            showAlert(title: "Error", message: "Por favor, ingresa un tiempo válido.")
//            return
//        }
//
//        if let timeInterval = TimeInterval(timeString) {
//            activateFocusMode(for: timeInterval)
//            scheduleNotification(for: timeInterval)
//            presentBlockingView()
//        } else {
//            showAlert(title: "Error", message: "Formato de tiempo no válido.")
//        }
//    }
//
//    func presentBlockingView() {
//        let blockingViewController = UIHostingController(rootView: BlockingView())
//        blockingViewController.modalPresentationStyle = .overFullScreen
//        present(blockingViewController, animated: true, completion: nil)
//        isFocused = true
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.isFocused = true
//        }
//    }
//
//    func requestScreenTimeAuthorization() {
//        AuthorizationCenter.shared.requestAuthorization { result in
//            switch result {
//            case .success:
//                print("Permiso de Screen Time concedido.")
//            case .failure(let error):
//                print("Error al solicitar permisos de Screen Time: \(error.localizedDescription)")
//                // Reintentar después de un tiempo
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                    self.requestScreenTimeAuthorization()
//                }
//            }
//        }
//    }
//
//    func requestNotificationAuthorization() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
//            if granted {
//                print("Permiso de notificaciones concedido.")
//            } else {
//                print("Permiso de notificaciones denegado.")
//            }
//        }
//    }
//
//    func activateFocusMode(for timeInterval: TimeInterval) {
//         print("Modo de enfoque activado por \(timeInterval) segundos.")
//         // ...
//         let notificationName = Notification.Name("FocusModeStateChanged")
//         NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["isFocusModeActive": true])
//     }
//
//    func scheduleNotification(for timeInterval: TimeInterval) {
//        let content = UNMutableNotificationContent()
//        content.title = "Activar App Focus Safe"
//        content.body = "Tu sesión de enfoque ha comenzado."
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
//        let request = UNNotificationRequest(identifier: "focusSafe", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print("Error al programar notificación: \(error)")
//            }
//        }
//    }
//
//    func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//}
//
//struct TimerViewControllerRepresentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> TimerViewController {
//        return TimerViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: TimerViewController, context: Context) {
//        // Actualiza la vista del controlador si es necesario
//    }
//}
