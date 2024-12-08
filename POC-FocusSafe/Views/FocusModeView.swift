//
//  FocusModeView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 6/11/24.
//

import SwiftUI
import Intents

// Extiende INFocusStatus para conformar a Identifiable
//extension INFocusStatus: Identifiable {
//    public var id: UUID {
//        return UUID()  // Genera un identificador único para cada elemento
//    }
//}
// No es necesario extender `INFocusStatus` aquí ya que no podemos directamente interactuar con Focus Mode.

//struct FocusModeView: View {
//    @ObservedObject var focusModeManager = FocusModeManager()
//
//    var body: some View {
//        VStack {
//            Button("Request Focus Mode Permissions") {
//                focusModeManager.requestFocusModePermissions()
//            }
//            List(focusModeManager.focusModes) { mode in
//                Text(mode.description)
//            }
//        }
//        .navigationTitle("Focus Mode")
//    }
//
//    /**
//     Integración de Focus Mode y App Intents
//     La integración con Focus Mode se realiza mediante App Intents, permitiendo activar un modo de enfoque que limite el uso del teléfono."""
//     **/
//
//    func activateFocusMode() {
//        let focusIntent = INSetFocusStatusIntent()
//        focusIntent.focusStatus = .focused
//        focusIntent.suggestedInvocationPhrase = "Activar modo de enfoque"
//
//        let interaction = INInteraction(intent: focusIntent, response: nil)
//        interaction.donate { (error) in
//            if let error = error {
//                print("Error al donar interacción: \(error)")
//            } else {
//                print("Focus Mode activado")
//            }
//        }
//    }
//}


struct FocusModeView: View {
    @ObservedObject var focusModeManager = FocusModeManager()

    var body: some View {
        VStack {
            Button("Request Focus Mode Permissions") {
                focusModeManager.requestFocusModePermissions()
            }

            List(focusModeManager.focusModes) { mode in
                Text(mode.status.description) // Asume que `description` es una propiedad de `INFocusStatus`
            }

            Button("Sugerir activación de Focus Mode") {
                suggestFocusModeShortcut()
            }
        }
        .navigationTitle("Focus Mode")
    }

    func suggestFocusModeShortcut() {
        // Crear una actividad de usuario para el modo de enfoque
        let activity = NSUserActivity(activityType: "com.tuApp.AppFocusSafe.activateFocusMode")
        activity.title = "Activar modo de enfoque en App Focus Safe"
        activity.suggestedInvocationPhrase = "Activar modo de enfoque en App Focus Safe"
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true

        // Marcar la actividad como relevante para atajos
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier("com.tuApp.AppFocusSafe.activateFocusMode")

        // Donar la actividad para que esté disponible en Siri y en el sistema
        activity.becomeCurrent()

        print("Atajo de enfoque sugerido")
    }


//    func suggestFocusModeShortcut() {
//        // Crear el intent para activar el enfoque
//        let intent = INSendMessageIntent()
//
//        // Crear un INPerson para "App Focus Safe"
//        let recipient = INPerson(
//            personHandle: INPersonHandle(value: "App Focus Safe", type: .unknown),
//            nameComponents: nil,
//            displayName: "App Focus Safe",
//            image: nil,
//            contactIdentifier: nil,
//            customIdentifier: nil
//        )
//
//        // Asignar el receptor del mensaje
//        intent.recipients = [recipient]
//
//        // Establecer el contenido del mensaje usando KVC (Key-Value Coding)
//        intent.setValue("Activar modo de enfoque", forKey: "content")
//
//        intent.suggestedInvocationPhrase = "Activar modo de enfoque en App Focus Safe"
//
//        // Donar la interacción para sugerir el atajo
//        let interaction = INInteraction(intent: intent, response: nil)
//        interaction.donate { (error) in
//            if let error = error {
//                print("Error al donar interacción: \(error)")
//            } else {
//                print("Atajo de enfoque sugerido")
//            }
//        }
//    }
}
