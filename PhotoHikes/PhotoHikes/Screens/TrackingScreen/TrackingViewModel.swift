//
//  TrackingViewModel.swift
//  PhotoHikes
//
//  Created by Markus on 23.07.24.
//

import SwiftUI
import CoreLocation
import NetworkService

@Observable @MainActor
final class TrackingViewModel {
    
    // MARK: - Properties
    
    private let flickrService: any FlickrServiceProtocol
    private let locationService: any LocationServiceProtocol

    private(set) var isTracking: Bool
    private(set) var trackedPhotos: [UIImage]
    private(set) var errorMessage: LocalizedStringKey?
    
    // MARK: - Initialize
    
    init(
        flickrService: any FlickrServiceProtocol,
        locationService: any LocationServiceProtocol
    ) {
        isTracking = false
        trackedPhotos = []
        
        self.locationService = locationService
        self.flickrService = flickrService
        
        // Initialized
        
        setUp()
    }
    
    private func setUp() {
        locationService.setOnUpdateLocation { [weak self] result in
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
                await stopTracking()
            } else {
                await startTracking()
            }
        }
    }
    
    func startTracking() async {
        isTracking = true
        trackedPhotos = []
        
        do {
            try await locationService.requestAuthorization()
            locationService.startUpdatingLocation()
        } catch LocationServiceError.invalidAuthorizationStatus {
            errorMessage = "required authorizationStatus `authorizedAlways` not granted!"
        } catch LocationServiceError.invalidAccuracy {
            errorMessage = "required accuracyAuthorization `fullAccuracy` not granted!"
        } catch {
            errorMessage = "unhandled error: \(String(describing: error))!"
        }
    }
    
    func stopTracking() async {
        isTracking = false
        locationService.stopUpdatingLocation()
    }
    
    private func processLocationUpdate(_ location: CLLocation) {
        debugPrint("location update: \(String(describing: location))")
        
        let coordinates = FlickrSearchCoordinates(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let image = try await flickrService.loadImage(at: coordinates)
                
                if let uiImage = UIImage(data: image) {
                    self.trackedPhotos.insert(uiImage, at: 0)
                } else {
                    // returned data from the service expected to contain valid image data.
                    assertionFailure("invalid image loaded!")
                }
            } catch {
                // handle Flickr api errors in a better way
                errorMessage = "Images cannot be loaded from Flickr, stopped tracking!"
                await stopTracking()
            }
            
        }
        
    }
}
