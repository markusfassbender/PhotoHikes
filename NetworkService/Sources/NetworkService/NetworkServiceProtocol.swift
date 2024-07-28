//
//  NetworkServiceProtocol.swift
//
//
//  Created by Markus on 28.07.24.
//

import Foundation

/// Provides a network service to use underlying networking, authentication, etc.
public protocol NetworkServiceProtocol {
    /// Loads data from a given url request.
    func load(_ urlRequest: URLRequest) async throws -> Data
}
