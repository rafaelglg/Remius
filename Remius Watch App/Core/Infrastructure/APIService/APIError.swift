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
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .itemNotFound:
            return "The requested information could not be found."
        case .decodingError:
            return "Failed to decode response"
        case .unauthorized:
            return "Unauthorized - Invalid token"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server error: \(statusCode)"
        }
    }
}
