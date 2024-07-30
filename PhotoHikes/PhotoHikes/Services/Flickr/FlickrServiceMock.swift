//
//  FlickrServiceMock.swift
//  PhotoHikes
//
//  Created by Markus on 30.07.24.
//

#if DEBUG

import Foundation

struct FlickrServiceMock: FlickrServiceProtocol {
    func loadImage(at coordinates: FlickrSearchCoordinates) async throws -> Data {
        fatalError("not implemented")
    }
}

#endif
