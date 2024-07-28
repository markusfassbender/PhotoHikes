//
//  NetworkServiceMock.swift
//
//
//  Created by Markus on 28.07.24.
//

#if DEBUG

import Foundation

struct NetworkServiceMock: NetworkServiceProtocol {
    func authorizedURLRequest(_ request: URLRequest, accessToken: String) -> URLRequest {
        request
    }
    
    func load(_ urlRequest: URLRequest) async throws -> Data {
        fatalError("not implemented")
    }
}

#endif
