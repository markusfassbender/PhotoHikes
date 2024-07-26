//
//  MockLocationService.swift
//  PhotoHikes
//
//  Created by Markus on 26.07.24.
//

import CoreLocation

#if DEBUG

struct LocationServiceMock: LocationServiceProtocol {
    func setOnUpdateLocation(_ onUpdateLocation: @escaping (Result<CLLocation, any Error>) -> Void) {
        fatalError("not implemented")
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
