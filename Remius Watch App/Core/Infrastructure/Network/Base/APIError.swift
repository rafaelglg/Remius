//
//  APIError.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case itemNotFound
    case decodingError
    case unauthorized
    case networkError(Error)
    case serverError(statusCode: Int)
    case configurationMissing(key: String)

    /// Technical description for logs and analytics. Never show to the user.
    var technicalDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL construction"
        case .itemNotFound:
            return "Resource not found (404)"
        case .decodingError:
            return "JSON decoding failed"
        case .unauthorized:
            return "Authentication failed (401)"
        case let .networkError(error):
            return "Network error: \(error.localizedDescription)"
        case let .serverError(statusCode):
            return "Server error: HTTP \(statusCode)"
        case let .configurationMissing(key):
            return "Missing config key: \(key)"
        }
    }
}
