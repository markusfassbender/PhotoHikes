//
//  FlickrService.swift
//  PhotoHikes
//
//  Created by Markus on 28.07.24.
//

import Foundation
import NetworkService

struct FlickrService: FlickrServiceProtocol {
    
    private let networkService: any NetworkServiceProtocol
    
    init(networkService: any NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadImage() async throws -> Data {
        // TODO: implement
        fatalError("not implemented")
    }
}
