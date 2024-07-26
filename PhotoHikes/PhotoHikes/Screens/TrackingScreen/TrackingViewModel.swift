//
//  TrackingViewModel.swift
//  PhotoHikes
//
//  Created by Markus on 23.07.24.
//

import SwiftUI
import CoreLocation

@Observable
final class TrackingViewModel {
    
    private var locationService: LocationService!
    
    var isTracking: Bool
    var errorMessage: LocalizedStringKey?
    
    init() {
        isTracking = false
    }
    
    func setUp() async {
        // temporary helper until dependency injection is available
        locationService = await LocationService()
        await locationService.setOnUpdateLocation { [weak self] result in
            switch result {
            case .success(let location):
                self?.processLocationUpdate(location)
            case .failure(let error):
                self?.errorMessage = "unhandled error: \(String(describing: error))!"
            }
            
        }
    }
    
    // MARK: - Tracking
    
    func trackingButtonTapped() {
        errorMessage = nil
        
        Task {
            if isTracking {
                isTracking = false
                await stopTracking()
            } else {
                isTracking = true
                await startTracking()
            }
        }
    }
    
    private func startTracking() async {
        do {
            try await locationService.requestAuthorization()
            await locationService.startUpdatingLocation()
        } catch LocationServiceError.invalidAuthorizationStatus {
            errorMessage = "required authorizationStatus `authorizedAlways` not granted!"
        } catch LocationServiceError.invalidAccuracy {
            errorMessage = "required accuracyAuthorization `fullAccuracy` not granted!"
        } catch {
            errorMessage = "unhandled error: \(String(describing: error))!"
        }
    }
    
    private func stopTracking() async {
        await locationService.stopUpdatingLocation()
    }
    
    private func processLocationUpdate(_ location: CLLocation) {
        debugPrint("location update: \(String(describing: location))")
    }
}
