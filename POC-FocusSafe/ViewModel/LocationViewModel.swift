//
//  LocationViewModel.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 25/10/24.
//

import CoreLocation
import SwiftUI
import MapKit

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.9266682, longitude: -72.5035725), // Coordenadas iniciales
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Nivel de zoom
    )
    @Published var permissionDenied = false
    private let locationManager = CLLocationManager()

    var centerPosition: CGPoint {
        // Calcula la posición de la anotación en la pantalla según la región
        let mapSize = UIScreen.main.bounds.size
        let mapRect = MKMapRect(
            x: 0, y: 0,
            width: mapSize.width,
            height: mapSize.height
        )
        let coordinatePoint = MKMapPoint(region.center)
        let point = CGPoint(
            x: coordinatePoint.x - mapRect.minX,
            y: coordinatePoint.y - mapRect.minY
        )
        return point
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermission() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            permissionDenied = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            permissionDenied = true
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            // Actualizamos la región con la nueva ubicación en tiempo real
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Zoom más cercano
            )
        }
    }
}
