//
//  NetworkServiceMock.swift
//
//
//  Created by Markus on 28.07.24.
//

#if DEBUG

import Foundation

final class NetworkServiceMock: NetworkServiceProtocol {
    
    var load_MockValue: Data?
    
    func authorizedURLRequest(_ request: URLRequest, accessToken: String) -> URLRequest {
        request
    }
    
    func load(_ urlRequest: URLRequest) async throws -> Data {
        if let load_MockValue {
            return load_MockValue
        }
        
        fatalError("not implemented")
    }
}

#endif
