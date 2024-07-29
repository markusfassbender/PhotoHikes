//
//  FlickrService.swift
//  PhotoHikes
//
//  Created by Markus on 28.07.24.
//

import Foundation
import NetworkService

struct FlickrService: FlickrServiceProtocol {
    
    private enum Constant {
        static let apiURLString = "https://api.flickr.com/services/rest/"
        static let photoURLString = "https://live.staticflickr.com"
        static let apiKey = "f28ecbe86a28cf727683cb576fdb63cb"
    }
    
    private let networkService: any NetworkServiceProtocol
    
    init(networkService: any NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Image
    
    func loadImage(at coordinates: FlickrSearchCoordinates) async throws -> Data {
        let list = try await loadImageList(at: coordinates)
        
        guard let photo = list.data.photos.first else {
            throw FlickrServiceError.emptyPhotoList
        }
        
        return try await loadImage(from: photo)
    }
    
    func loadImage(from photo: FlickrImageList.Photo) async throws -> Data {
        let urlRequest = makeImageURLRequest(of: photo)
        return try await networkService.load(urlRequest)
    }
    
    func makeImageURLRequest(of photo: FlickrImageList.Photo) -> URLRequest {
        // Docs: https://www.flickr.com/services/api/misc.urls.html
        var urlComponents = URLComponents(string: Constant.photoURLString)
        urlComponents?.path = "/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        
        guard let url = urlComponents?.url else {
            // TODO: handle errors in a better way
            fatalError("developer error: URL cannot be build!")
        }
        
        return URLRequest(url: url)
    }
    
    // MARK: Image List
    
    func loadImageList(at coordinates: FlickrSearchCoordinates) async throws -> FlickrImageList {
        let urlRequest = makeImageListURLRequest(coordinates: coordinates)
        let data = try await networkService.load(urlRequest)
        return try decodeImageList(data)
    }
    
    private func decodeImageList(_ data: Data) throws -> FlickrImageList {
        let decoder = JSONDecoder()
        let jsonData = extractImageListJSONData(from: data)
        return try decoder.decode(FlickrImageList.self, from: jsonData)
    }
    
    private func extractImageListJSONData(from data: Data) -> Data {
        // WORKAROUND: remove non json string around the decodable json!
        var string = String(decoding: data, as: UTF8.self)
        string = string.replacingOccurrences(of: "jsonFlickrApi(", with: "")
        string.removeLast() // the last character is ")"
        
        return Data(string.utf8)
    }
    
    func makeImageListURLRequest(coordinates: FlickrSearchCoordinates) -> URLRequest {
        // Docs: https://www.flickr.com/services/api/flickr.photos.search.html
        var urlComponents = URLComponents(string: Constant.apiURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: Constant.apiKey),
            URLQueryItem(name: "content_types", value: "0"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "media", value: "photos"),
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "lat", value: formattedCoordinate(coordinates.latitude)),
            URLQueryItem(name: "lon", value: formattedCoordinate(coordinates.longitude))
        ]
        
        guard let url = urlComponents?.url else {
            // TODO: handle errors in a better way
            fatalError("developer error: URL cannot be build!")
        }
        
        return URLRequest(url: url)
    }
    
    /// Returns a formatted coordinate with a precision of approximately 1meter.
    private func formattedCoordinate(_ coordinate: Double) -> String {
        // Coordinates Decimal Rounding: https://en.wikipedia.org/wiki/Decimal_degrees
        // Would it make sense to reduce precision to improve the user's privacy?
        String(format: "%.5f", coordinate)
    }
}
