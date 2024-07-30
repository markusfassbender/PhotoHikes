//
//  LocationService.swift
//  PhotoHikes
//
//  Created by Markus on 25.07.24.
//

import CoreLocation

/// Service to provide access to `CoreLocation` to track the device location.
@MainActor
final class LocationService: NSObject, LocationServiceProtocol {
    
    private enum Constant {
        static let minDistanceFilter: CLLocationDistance = 100
    }
    
    // MARK: - Properties
    
    private let locationManager: CLLocationManager
    
    private var authorizationContinuation: CheckedContinuation<Void, any Error>?
    
    /// Process the location updates or errors.
    var onUpdateLocation: ((Result<CLLocation, any Error>) -> Void)?
    
    // MARK: - Initialize
    
    override init() {
        locationManager = CLLocationManager()
        
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
        case .authorizedWhenInUse, .authorizedAlways:
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
            try await withCheckedThrowingContinuation { continuation in
                authorizationContinuation = continuation
            }
        case .denied, .restricted:
            throw LocationServiceError.invalidAuthorizationStatus
        @unknown default:
            throw LocationServiceError.invalidAuthorizationStatus
        }
    }

    func startUpdatingLocation() {
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = Constant.minDistanceFilter
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        default:
            authorizationContinuation?.resume(throwing: LocationServiceError.invalidAuthorizationStatus)
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
