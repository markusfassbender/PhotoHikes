//
//  MockLocationService.swift
//  PhotoHikes
//
//  Created by Markus on 26.07.24.
//

import CoreLocation

#if DEBUG

final class LocationServiceMock: LocationServiceProtocol {
    
    func setOnUpdateLocation(_ onUpdateLocation: @escaping (Result<CLLocation, any Error>) -> Void) { }
    
    func requestAuthorization() async throws { }
    
    func startUpdatingLocation() { }
    
    func stopUpdatingLocation() { }
}

#endif
