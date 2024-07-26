//
//  LocationServiceProtocol.swift
//  PhotoHikes
//
//  Created by Markus on 26.07.24.
//

import CoreLocation

@MainActor
protocol LocationServiceProtocol {
    
    func setOnUpdateLocation(_ onUpdateLocation: @escaping (Result<CLLocation, any Error>) -> Void)
    
    /// Requests user to grant authorization. Throws `LocationServiceError` on failure or insufficient requirements.
    func requestAuthorization() async throws
    
    /// Starts delivering the location updates.
    func startUpdatingLocation()
    
    /// Stops location updates.
    func stopUpdatingLocation()
}
