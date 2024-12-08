//
//  MainView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 10/11/24.
//

import SwiftUI
import Combine

struct MainView: View {
    @StateObject private var screenTimeManager = ScreenTimeManager()
    @StateObject private var focusModeManager = FocusModeManager()
    @StateObject private var notificationManager = NotificationManager()

    @State private var timeValue: Int = 0
    @State private var isHours: Bool = true
    @State private var timer: Timer?
    @State private var countdown: Int = 0

    var body: some View {
        VStack {
            TextField("Enter time", value: $timeValue, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Toggle(isOn: $isHours) {
                Text("Hours")
            }
            .padding()

            Text("\(countdown) \(isHours ? "hours" : "minutes") left")
                .padding()

            List(screenTimeManager.screenTimeData) { app in
                HStack {
                    Text(app.description)
                    Spacer()
                    Toggle("", isOn: Binding<Bool>(
                        get: { self.screenTimeManager.selectedApps.contains(app.description) },
                        set: { _ in self.screenTimeManager.toggleAppSelection(app) }
                    ))
                }
            }

            Button(action: {
                startTimer()
            }) {
                Text("Start Timer")
            }
            .disabled(timeValue == 0)
        }
        .onAppear {
            screenTimeManager.requestScreenTimePermissions()
            focusModeManager.requestFocusModePermissions()
            notificationManager.requestNotificationPermissions()
        }
    }

    private func startTimer() {
        countdown = isHours ? timeValue * 60 : timeValue
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer?.invalidate()
                timer = nil
                // Aquí puedes agregar la lógica para restringir el acceso a las aplicaciones y mostrar notificaciones
            }
        }
    }
}
