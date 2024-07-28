//
//  NetworkServiceError.swift
//
//
//  Created by Markus on 28.07.24.
//

import Foundation

public enum NetworkServiceError: Error {
    case invalidResponse
    case badStatusCode(statusCode: Int, data: Data)
}
