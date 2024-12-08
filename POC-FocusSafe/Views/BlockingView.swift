//
//  BlockingView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 12/11/24.
//

import SwiftUI
import BackgroundTasks

// TODO: NUEVA IMPLEMENTACION

struct BlockingView: View {
    @State private var start = false
    @State private var to: CGFloat = 0
    @State private var count = 0
    @State private var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isBlocked = false
    var totalTime: TimeInterval


    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 35, lineCap: .round))
                        .frame(width: 280, height: 280)

                    Circle()
                        .trim(from: 0, to: self.to)
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 35, lineCap: .round))
                        .frame(width: 280, height: 280)
                        .rotationEffect(.init(degrees: -90))

                    VStack {
                        Text("\(self.count)")
                            .font(.system(size: 65))
                            .fontWeight(.bold)

                        Text("Of \(Int(totalTime))")
                            .font(.title)
                            .padding(.top)
                    }
                }

                HStack(spacing: 20) {
                    Button(action: {
                        if self.count == Int(totalTime) {
                            self.count = 0
                            withAnimation(.default) {
                                self.to = 0
                            }
                        }
                        self.start.toggle()
                        if self.start {
                            self.isBlocked = true
                            scheduleBackgroundTask()
                        }
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: self.start ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)

                            Text(self.start ? "Pause" : "Play")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .shadow(radius: 6)
                    }

                    Button(action: {
                        self.count = 0

                        withAnimation(.default) {
                            self.to = 0
                        }
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.red)

                            Text("Restart")
                                .foregroundColor(.red)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(
                            Capsule()
                                .stroke(Color.red, lineWidth: 2)
                        )
                        .shadow(radius: 6)
                    }
                }
                .padding(.top, 55)
            }
        }
        .onTapGesture {
            // Manejar el evento de toque
            let gestoDetecte = UISwipeGestureRecognizer.Direction.self
            debugPrint(" Gesto fue \(gestoDetecte)")
        }
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
            }
            startTimer()
        })
        .onReceive(self.time) { (_) in
            if self.start {
                if self.count != Int(totalTime) {
                    self.count += 1
                    withAnimation(.default) {
                        self.to = CGFloat(self.count) / CGFloat(totalTime)
                    }
                } else {
                    self.start.toggle()
                    self.isBlocked = false
                    self.notify()
                }
            }
        }
        .disabled(isBlocked)
        .overlay(
            isBlocked ? Color.black.opacity(0.5) : Color.clear
        )
        // GESTURE:
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.height < 0 {
                        // Swipe hacia arriba
                        handleSwipeUp()
                    }
                }
        )
    }

    func startTimer() {
        self.start = true
        self.isBlocked = true
    }

    func notify() {
        let content = UNMutableNotificationContent()
        content.title = "Focus Safe Message"
        content.body = "Timer Is Completed Successfully In Background !!!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }

    func notifyCierre() {
        let content = UNMutableNotificationContent()
        content.title = "Cierre Applicacion."
        content.body = "Timer Is Completed Successfully In Background !!!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }

    func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.app.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1) // 1 second from now

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    func handleSwipeUp() {
        /**Aquí puedes realizar la acción que deseas cuando se detecta un swipe hacia arriba
        Por ejemplo, mostrar una alerta o cambiar de vista **/
        let alert = UIAlertController(title: "Swipe Detected", message: "Swipe hacia arriba detectado", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            notifyCierre()
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
}
