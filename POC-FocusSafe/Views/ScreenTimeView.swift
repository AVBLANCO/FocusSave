//
//  ScreenTimeView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 6/11/24.
//

import SwiftUI

struct ScreenTimeView: View {
    @ObservedObject var screenTimeManager = ScreenTimeManager()

    var body: some View {
        VStack {
            Button("Request Screen Time Permissions") {
                screenTimeManager.requestScreenTimePermissions()
            }

            List(screenTimeManager.screenTimeData) { data in
                Text(data.description)
            }

            Button("Restrict App Usage") {
                screenTimeManager.restrictAppUsage(appIdentifiers: [
                    "com.facebook.Facebook",
                    "com.google.chrome.ios",
                    "com.burbn.instagram",
                    "com.zhiliaoapp.musically",
                    "com.atebits.Tweetie2"
                ], restricted: true)
            }

            Button("Unrestrict App Usage") {
                screenTimeManager.restrictAppUsage(appIdentifiers: [
                    "com.facebook.Facebook",
                    "com.google.chrome.ios",
                    "com.burbn.instagram",
                    "com.zhiliaoapp.musically",
                    "com.atebits.Tweetie2"
                ], restricted: false)
            }

            // Simplificación: una lista de aplicaciones para seleccionar
            VStack {
                Text("Select Apps to Restrict:")
                    .font(.headline)

                List(screenTimeManager.screenTimeData) { app in
                    HStack {
                        Text(app.description)
                        Spacer()
                        // Verifica si la descripción de la aplicación está en el conjunto `selectedApps`
                        Image(systemName: screenTimeManager.selectedApps.contains(app.description) ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                // Alterna el estado de restricción de la aplicación
                                screenTimeManager.toggleAppSelection(app)
                            }
                    }
                }
            }
        }
        .navigationTitle("Screen Time")
    }
}
