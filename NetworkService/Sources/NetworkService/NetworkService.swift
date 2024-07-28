//
//  NetworkService.swift
//
//
//  Created by Markus on 28.07.24.
//

import Foundation

public final class NetworkService: NetworkServiceProtocol {
    
    private let urlSession: URLSession
    
    // MARK: - Initialized
    
    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    // MARK: - Methods
    
    public func load(_ urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkServiceError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<400:
            return data
        default:
            throw NetworkServiceError.badStatusCode(statusCode: httpResponse.statusCode, data: data)
        }
    }
}
