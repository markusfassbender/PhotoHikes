//
//  LocationService.swift
//  PhotoHikes
//
//  Created by Markus on 25.07.24.
//

import CoreLocation

/// Service to provide access to `CoreLocation` to track the device location.
@MainActor @Observable
final class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    
    private var authorizationContinuation: CheckedContinuation<Void, any Error>?
    
    override init() {
        super.init()
        
        // Configure the location manager.
        locationManager.delegate = self
    }
    
    /// Requests user to grant authorization. Throws `LocationServiceError` on failure or insufficient requirements.
    func requestAuthorization() async throws {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            return
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            
            try await withCheckedThrowingContinuation { continuation in
                self.authorizationContinuation = continuation
            }
        case .denied, .restricted, .authorizedWhenInUse:
            throw LocationServiceError.invalidAuthorizationStatus
        @unknown default:
            throw LocationServiceError.invalidAuthorizationStatus
        }
    }
    
    /// Starts delivering the location updates.
    func liveUpdates() -> CLLocationUpdate.Updates {
        CLLocationUpdate.liveUpdates(.fitness)
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard case .authorizedAlways = manager.authorizationStatus else {
            authorizationContinuation?.resume(throwing: LocationServiceError.invalidAuthorizationStatus)
            return
        }
        
        guard case .fullAccuracy = manager.accuracyAuthorization else {
            authorizationContinuation?.resume(throwing: LocationServiceError.invalidAccuracy)
            return
        }
        
        authorizationContinuation?.resume()
        authorizationContinuation = nil
    }
}
