//
//  Profile.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 6/11/24.
//

import Foundation
import Intents
import IntentsUI

struct Profile: Identifiable {
    let id: UUID
    var name: String
    var restrictions: [String] // Lista de aplicaciones restringidas, por ejemplo
    var screenTimeLimit: TimeInterval // Límite de tiempo de uso en segundos
    var notificationEnabled: Bool // Indica si están habilitadas las notificaciones de límite
}


struct ScreenTimeData: Identifiable {
    var id = UUID()  // O usa otra propiedad única si ya existe
    var description: String
}


// nuevo
struct FocusMode: Identifiable {
    let id = UUID()
    let status: INFocusStatus
}

// Gestion de estados de la aplicacion:
struct AppInfo: Identifiable {
    let id = UUID()
    let bundleIdentifier: String
    let isSuspended: Bool
}

