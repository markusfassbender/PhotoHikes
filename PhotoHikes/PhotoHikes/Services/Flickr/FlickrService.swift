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
        static let apiKey = "f28ecbe86a28cf727683cb576fdb63cb" // TODO find a way to enter your own API value
    }
    
    private let networkService: any NetworkServiceProtocol
    
    init(networkService: any NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadImage() async throws -> Data {
        try await loadImageList()
    }
    
    func loadImageList() async throws -> Data {
        let urlRequest = makeImageListURLRequest()
        let data = try await networkService.load(urlRequest)
        
        // TODO: implement decoding
        
        return data
    }
    
    func makeImageListURLRequest() -> URLRequest {
        // Docs: https://www.flickr.com/services/api/flickr.photos.search.html
        var urlComponents = URLComponents(string: Constant.apiURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: Constant.apiKey),
            URLQueryItem(name: "content_types", value: "0,1"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "media", value: "photos"),
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "lat", value: "51"),
            URLQueryItem(name: "lon", value: "7")
        ]
        
        guard let url = urlComponents?.url else {
            // TODO: handle errors in a better way
            fatalError("developer error: URL cannot be build!")
        }
        
        return URLRequest(url: url)
    }
}
