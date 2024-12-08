//
//  ContentView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 25/10/24.
//

import SwiftUI

@available(iOS 17.0, *)
struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Contactos", destination: ContactsView())
                NavigationLink("Ubicación", destination: LocationView())
                NavigationLink("Calendario", destination: CalendarView())
                NavigationLink("Fotos", destination: PhotosView())
                NavigationLink("Screen Time", destination: ScreenTimeView())
                NavigationLink("Focus Mode", destination: FocusModeView())
                //NavigationLink("Gestión de Perfiles", destination: ProfileManagementView())
                NavigationLink("Gestión de Perfiles", destination: ProfileView())
                // Device Managemnet
                NavigationLink(" -> TimerView", destination: TimerView())
                NavigationLink("TimerView", destination: TimerViewControllerRepresentable())
                NavigationLink("DeviceManagementView", destination: DeviceManagementView())
                NavigationLink("MainView", destination: MainView())
                Text(Bundle.main.bundleIdentifier ?? "Bundle Identifier no disponible")

            }
            .navigationTitle("Permisos")
        }
    }
}
