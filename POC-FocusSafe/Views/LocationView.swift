//
//  LocationView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 25/10/24.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct LocationView: View {
    @StateObject private var viewModel = LocationViewModel()

    var body: some View {
        VStack {
            if viewModel.permissionDenied {
                Text("Permiso de ubicación denegado.")
                    .foregroundColor(.red)
            } else {
                Map(coordinateRegion: $viewModel.region)
                    .overlay(
                        Circle()
                            .stroke(Color.blue, lineWidth: 3)
                            .frame(width: 15, height: 15)
                            .position(viewModel.centerPosition)
                    )
                    .onAppear {
                        viewModel.requestPermission()
                    }
                    .mapStyle(.standard)
                    .mapControls {
                        MapUserLocationButton()
                    }
            }
        }
        .navigationTitle("Ubicación")
    }
}
