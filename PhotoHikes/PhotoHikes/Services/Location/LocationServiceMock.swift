//
//  MockLocationService.swift
//  PhotoHikes
//
//  Created by Markus on 26.07.24.
//

import CoreLocation

#if DEBUG

final class LocationServiceMock: LocationServiceProtocol {
    
    private var setOnUpdateLocation_mockValue: ((Result<CLLocation, any Error>) -> Void)?
    
    func setOnUpdateLocation(_ onUpdateLocation: @escaping (Result<CLLocation, any Error>) -> Void) {
        self.setOnUpdateLocation_mockValue = onUpdateLocation
    }
    
    func requestAuthorization() async throws {
        fatalError("not implemented")
    }
    
    func startUpdatingLocation() {
        fatalError("not implemented")
    }
    
    func stopUpdatingLocation() {
        fatalError("not implemented")
    }
}

#endif
