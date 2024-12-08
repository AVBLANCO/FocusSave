////
////  TimerView.swift
////  POC-FocusSave
////
////  Created by Victor Manuel Blanco Mancera on 8/11/24.
////
//

import SwiftUI
import BackgroundTasks

struct TimerView: View {
    @State var start = false
    @State var to: CGFloat = 0
    @State var count = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)

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

                        Text("Of 15")
                            .font(.title)
                            .padding(.top)
                    }
                }

                HStack(spacing: 20) {
                    Button(action: {
                        if self.count == 15 {
                            self.count = 0
                            withAnimation(.default) {
                                self.to = 0
                            }
                        }
                        self.start.toggle()
                        if self.start {
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
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
            }
        })
        .onReceive(self.time) { (_) in
            if self.start {
                if self.count != 15 {
                    self.count += 1
                    withAnimation(.default) {
                        self.to = CGFloat(self.count) / 15
                    }
                } else {
                    self.start.toggle()
                    self.notify()
                }
            }
        }
    }

    func notify() {
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.body = "Timer Is Completed Successfully In Background !!!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }

    func scheduleBackgroundTask() {
       //let request = BGAppRefreshTaskRequest(identifier: "com.example.app.refresh")
        let request = BGAppRefreshTaskRequest(identifier: "personal.POC-FocusSafe")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1) // 1 second from now

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}


//import SwiftUI
//import UserNotifications
//
////struct TimerView: UIViewControllerRepresentable {
////    func makeUIViewController(context: Context) -> TimerViewController {
////        return TimerViewController()
////    }
////
////    func updateUIViewController(_ uiViewController: TimerViewController, context: Context) {
////        // Actualiza la vista si es necesario
////    }
////}
//
//import SwiftUI
//import BackgroundTasks
//
//struct TimerView: View {
//    @State var start = false
//    @State var to: CGFloat = 0
//    @State var count = 0
//    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)
//
//            VStack {
//                ZStack {
//                    Circle()
//                        .trim(from: 0, to: 1)
//                        .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 35, lineCap: .round))
//                        .frame(width: 280, height: 280)
//
//                    Circle()
//                        .trim(from: 0, to: self.to)
//                        .stroke(Color.red, style: StrokeStyle(lineWidth: 35, lineCap: .round))
//                        .frame(width: 280, height: 280)
//                        .rotationEffect(.init(degrees: -90))
//
//                    VStack {
//                        Text("\(self.count)")
//                            .font(.system(size: 65))
//                            .fontWeight(.bold)
//
//                        Text("Of 15")
//                            .font(.title)
//                            .padding(.top)
//                    }
//                }
//
//                HStack(spacing: 20) {
//                    Button(action: {
//                        if self.count == 15 {
//                            self.count = 0
//                            withAnimation(.default) {
//                                self.to = 0
//                            }
//                        }
//                        self.start.toggle()
//                        if self.start {
//                            scheduleBackgroundTask()
//                        }
//                    }) {
//                        HStack(spacing: 15) {
//                            Image(systemName: self.start ? "pause.fill" : "play.fill")
//                                .foregroundColor(.white)
//
//                            Text(self.start ? "Pause" : "Play")
//                                .foregroundColor(.white)
//                        }
//                        .padding(.vertical)
//                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
//                        .background(Color.red)
//                        .clipShape(Capsule())
//                        .shadow(radius: 6)
//                    }
//
//                    Button(action: {
//                        self.count = 0
//
//                        withAnimation(.default) {
//                            self.to = 0
//                        }
//                    }) {
//                        HStack(spacing: 15) {
//                            Image(systemName: "arrow.clockwise")
//                                .foregroundColor(.red)
//
//                            Text("Restart")
//                                .foregroundColor(.red)
//                        }
//                        .padding(.vertical)
//                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
//                        .background(
//                            Capsule()
//                                .stroke(Color.red, lineWidth: 2)
//                        )
//                        .shadow(radius: 6)
//                    }
//                }
//                .padding(.top, 55)
//            }
//        }
//        .onAppear(perform: {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
//            }
//        })
//        .onReceive(self.time) { (_) in
//            if self.start {
//                if self.count != 15 {
//                    self.count += 1
//                    withAnimation(.default) {
//                        self.to = CGFloat(self.count) / 15
//                    }
//                } else {
//                    self.start.toggle()
//                    self.notify()
//                }
//            }
//        }
//    }
//
//    func notify() {
//        let content = UNMutableNotificationContent()
//        content.title = "Message"
//        content.body = "Timer Is Completed Successfully In Background !!!"
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//
//        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
//    }
//
//    func scheduleBackgroundTask() {
//        let request = BGAppRefreshTaskRequest(identifier: "com.example.app.refresh")
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 1) // 1 second from now
//
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("Could not schedule app refresh: \(error)")
//        }
//    }
//}
//
