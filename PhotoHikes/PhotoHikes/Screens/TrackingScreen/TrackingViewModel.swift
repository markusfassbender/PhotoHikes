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
    }
    
    // MARK: - Tracking
    
    func trackingButtonTapped() {
        errorMessage = nil
        
        Task {
            if isTracking {
                stopTracking()
            } else {
                await startTracking()
            }
        }
    }
    
    private func startTracking() async {
        isTracking = true
        
        do {
            try await locationService.requestAuthorization()
            
            for try await locationUpdate in await locationService.liveUpdates() {
                processLocationUpdate(locationUpdate)
            }
        } catch LocationServiceError.invalidAuthorizationStatus {
            errorMessage = "required authorizationStatus `authorizedAlways` not granted!"
        } catch LocationServiceError.invalidAccuracy {
            errorMessage = "required accuracyAuthorization `fullAccuracy` not granted!"
        } catch {
            errorMessage = "unhandled error!"
        }
        
    }
    
    private func stopTracking() {
        isTracking = false
        
        // TODO: stop running services
    }
    
    private func processLocationUpdate(_ locationUpdate: CLLocationUpdate) {
        debugPrint("location update: \(String(describing: locationUpdate))")
    }
}
