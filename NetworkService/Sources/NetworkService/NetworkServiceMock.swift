//
//  NetworkServiceMock.swift
//
//
//  Created by Markus on 28.07.24.
//

#if DEBUG

import Foundation

final class NetworkServiceMock: NetworkServiceProtocol {
    
    var load_mockValue: Data?
    var load_mockMethod: ((URLRequest) throws -> Data)?
    
    func authorizedURLRequest(_ request: URLRequest, accessToken: String) -> URLRequest {
        request
    }
    
    func load(_ urlRequest: URLRequest) async throws -> Data {
        if let load_mockValue {
            return load_mockValue
        }
        
        if let load_mockMethod {
            return try load_mockMethod(urlRequest)
        }
        
        fatalError("not implemented")
    }
}

#endif
