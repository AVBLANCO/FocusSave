//
//  TimerViewController.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 8/11/24.
//
//

import SwiftUI
import UIKit
import FamilyControls
import Intents
import UserNotifications
import MobileCoreServices
import ManagedSettings
import DeviceActivity

// TODO: nueva implementacion
class TimerViewController: UIViewController {

    var timeTextField: UITextField!
    var startButton: UIButton!
    var hoursButton: UIButton!
    var minutesButton: UIButton!
    var secondsButton: UIButton!
    var screenTimeManager = ScreenTimeManager()
    var isFocused = false
    var selectedUnit: TimeUnit = .seconds

    enum TimeUnit: String {
        case hours
        case minutes
        case seconds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestScreenTimeAuthorization()
        requestNotificationAuthorization()
    }

    func setupUI() {
        view.backgroundColor = .white

        timeTextField = UITextField()
        timeTextField.placeholder = "Ingresa el tiempo"
        timeTextField.borderStyle = .roundedRect
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeTextField)

        startButton = UIButton(type: .system)
        startButton.setTitle("Iniciar", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)

        hoursButton = UIButton(type: .system)
        hoursButton.setTitle("Horas", for: .normal)
        hoursButton.addTarget(self, action: #selector(hoursButtonTapped), for: .touchUpInside)
        hoursButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hoursButton)

        minutesButton = UIButton(type: .system)
        minutesButton.setTitle("Minutos", for: .normal)
        minutesButton.addTarget(self, action: #selector(minutesButtonTapped), for: .touchUpInside)
        minutesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(minutesButton)

        secondsButton = UIButton(type: .system)
        secondsButton.setTitle("Segundos", for: .normal)
        secondsButton.addTarget(self, action: #selector(secondsButtonTapped), for: .touchUpInside)
        secondsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondsButton)

        NSLayoutConstraint.activate([
            timeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            timeTextField.widthAnchor.constraint(equalToConstant: 200),

            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 20),

            hoursButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            hoursButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),

            minutesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minutesButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),

            secondsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            secondsButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20)
        ])
    }

//    @objc func startButtonTapped() {
//        guard let timeString = timeTextField.text, !timeString.isEmpty else {
//            showAlert(title: "Error", message: "Por favor, ingresa un tiempo válido.")
//            return
//        }
//
//        if let timeInterval = TimeInterval(timeString) {
//            let totalTime = convertToSeconds(timeInterval)
//            activateFocusMode(for: totalTime)
//            scheduleNotification(for: totalTime)
//            presentBlockingView(totalTime: totalTime)
//        } else {
//            showAlert(title: "Error", message: "Formato de tiempo no válido.")
//        }
//    }
    @objc func startButtonTapped() {
        guard let timeString = timeTextField.text, !timeString.isEmpty else {
            showAlert(title: "Error", message: "Por favor, ingresa un tiempo válido.")
            return
        }

        if let timeInterval = TimeInterval(timeString) {
            let totalTime = convertToSeconds(timeInterval)
            activateFocusMode(for: totalTime)
            scheduleNotification(for: totalTime)
            saveFocusState(true, time: totalTime, unit: selectedUnit)
            presentBlockingView(totalTime: totalTime)
        } else {
            showAlert(title: "Error", message: "Formato de tiempo no válido.")
        }
    }

    func saveFocusState(_ isFocused: Bool, time: TimeInterval, unit: TimeUnit) {
        UserDefaults.standard.set(isFocused, forKey: "isFocused")
        UserDefaults.standard.set(time, forKey: "focusTime")
        UserDefaults.standard.set(unit.rawValue, forKey: "focusUnit")
    }

    @objc func hoursButtonTapped() {
        selectedUnit = .hours
    }

    @objc func minutesButtonTapped() {
        selectedUnit = .minutes
    }

    @objc func secondsButtonTapped() {
        selectedUnit = .seconds
    }

    func convertToSeconds(_ timeInterval: TimeInterval) -> TimeInterval {
        switch selectedUnit {
        case .hours:
            return timeInterval * 3600
        case .minutes:
            return timeInterval * 60
        case .seconds:
            return timeInterval
        }
    }

    func presentBlockingView(totalTime: TimeInterval) {
        let blockingViewController = UIHostingController(rootView: BlockingView(totalTime: totalTime))
        blockingViewController.modalPresentationStyle = .overFullScreen
        present(blockingViewController, animated: true, completion: nil)
        isFocused = true
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.isFocused = true
        }
    }

//    func presentBlockingView() {
//        let blockingViewController = UIHostingController(rootView: BlockingView())
//        blockingViewController.modalPresentationStyle = .overFullScreen
//        present(blockingViewController, animated: true, completion: nil)
//        isFocused = true
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.isFocused = true
//        }
//    }

    func requestScreenTimeAuthorization() {
        AuthorizationCenter.shared.requestAuthorization { result in
            switch result {
            case .success:
                print("Permiso de Screen Time concedido.")
            case .failure(let error):
                print("Error al solicitar permisos de Screen Time: \(error.localizedDescription)")
                // Reintentar después de un tiempo
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.requestScreenTimeAuthorization()
                }
            }
        }
    }

    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Permiso de notificaciones concedido.")
            } else {
                print("Permiso de notificaciones denegado.")
            }
        }
    }

    func activateFocusMode(for timeInterval: TimeInterval) {
         print("Modo de enfoque activado por \(timeInterval) segundos.")
         // ...
         let notificationName = Notification.Name("FocusModeStateChanged")
         NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["isFocusModeActive": true])
     }

    func scheduleNotification(for timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Activar App Focus Safe"
        content.body = "Tu sesión de enfoque ha comenzado."

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: "focusSafe", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error al programar notificación: \(error)")
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

struct TimerViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TimerViewController {
        return TimerViewController()
    }

    func updateUIViewController(_ uiViewController: TimerViewController, context: Context) {
        // Actualiza la vista del controlador si es necesario
    }
}
