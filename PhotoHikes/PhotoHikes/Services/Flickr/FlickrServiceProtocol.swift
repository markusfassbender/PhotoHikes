//
//  FlickrServiceProtocol.swift
//  PhotoHikes
//
//  Created by Markus on 28.07.24.
//

import Foundation

protocol FlickrServiceProtocol {
    func loadImage(at coordinates: FlickrSearchCoordinates) async throws -> Data
}
