//
//  FlickrImageList.swift
//  PhotoHikes
//
//  Created by Markus on 29.07.24.
//

import Foundation

struct FlickrImageList: Decodable {
    enum CodingKeys: String, CodingKey {
        case data = "photos"
    }
    
    let data: Data
}

// MARK: - Photos

extension FlickrImageList {
    struct Data: Decodable {
        enum CodingKeys: String, CodingKey {
            case photos = "photo"
        }
        
        let photos: [Photo]
    }
}

// MARK: - Photo

extension FlickrImageList {
    struct Photo: Decodable {
        let id: String
        let server: String
        let secret: String
        
        init(
            id: String,
            server: String,
            secret: String
        ) {
            self.id = id
            self.server = server
            self.secret = secret
        }
    }
}
