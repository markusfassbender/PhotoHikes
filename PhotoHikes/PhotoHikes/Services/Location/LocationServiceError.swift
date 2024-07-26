//
//  LocationServiceError.swift
//  PhotoHikes
//
//  Created by Markus on 25.07.24.
//

enum LocationServiceError: Error {
    case invalidAuthorizationStatus
    case invalidAccuracy
    case failure(error: any Error)
}
