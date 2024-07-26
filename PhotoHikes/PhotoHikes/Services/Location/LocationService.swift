//
//  LocationService.swift
//  PhotoHikes
//
//  Created by Markus on 25.07.24.
//

import CoreLocation

/// Service to provide access to `CoreLocation` to track the device location.
@MainActor @Observable
final class LocationService: NSObject, LocationServiceProtocol {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    
    private var authorizationContinuation: CheckedContinuation<Void, any Error>?
    
    /// Process the location updates or errors.
    var onUpdateLocation: ((Result<CLLocation, any Error>) -> Void)?
    
    // MARK: - Initialize
    
    override init() {
        super.init()
        // self initialized
        locationManager.delegate = self
    }
    
    func setOnUpdateLocation(_ onUpdateLocation: @escaping (Result<CLLocation, any Error>) -> Void) {
        self.onUpdateLocation = onUpdateLocation
    }
    
    // MARK: - Location
    
    func requestAuthorization() async throws {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            return
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            
            try await withCheckedThrowingContinuation { continuation in
                authorizationContinuation = continuation
            }
        case .denied, .restricted, .authorizedWhenInUse:
            throw LocationServiceError.invalidAuthorizationStatus
        @unknown default:
            throw LocationServiceError.invalidAuthorizationStatus
        }
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        onUpdateLocation?(.success(location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        onUpdateLocation?(.failure(error))
    }
}
