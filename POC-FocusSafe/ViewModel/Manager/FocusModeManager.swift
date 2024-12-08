//
//  FocusModeManager.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 6/11/24.
//

import Foundation
import Intents

class FocusModeManager: ObservableObject {
    @Published var focusModes: [FocusMode] = []

    func requestFocusModePermissions() {
        // Verifica si el estado de autorización es "authorized"
        if INFocusStatusCenter.default.authorizationStatus == .authorized {
            // Permiso otorgado, llama a `fetchFocusModes`
            fetchFocusModes()
        } else {
            // No tiene autorización, maneja el caso o pide al usuario que active los permisos
            print("Focus Mode permissions not granted.")
        }
    }

    func fetchFocusModes() {
        // Implementa la lógica para obtener y procesar los modos de enfoque
        let statuses = [INFocusStatus]() // Aquí cargarías los estados reales

        // Transforma cada `INFocusStatus` en un `FocusMode` y actualiza `focusModes`
        focusModes = statuses.map { FocusMode(status: $0) }
    }
}
