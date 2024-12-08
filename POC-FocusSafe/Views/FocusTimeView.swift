//
//  FocusTimeView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 8/11/24.
//

import SwiftUI

struct FocusTimeView: View {
    @State private var focusTime: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Configura tu tiempo de enfoque")
                .font(.title)
            TextField("Tiempo en minutos", value: $focusTime, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            Button(action: startFocusSession) {
                Text("Iniciar")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    func startFocusSession() {
        // Lógica para iniciar sesión de enfoque
    }
}
