//
//  RemiusEndpoint.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

import Foundation

enum RemiusEndpoints: Equatable {
    case oauth2Token
    case absolute(url: URL?)
    case flightStatus(flightNumber: String, date: String)
    
    /// The path component of the endpoint.
    ///
    /// For `.absolute`, this returns an empty string since the full URL is provided.
    var path: String {
        switch self {
        case .oauth2Token:
            return "/v1/security/oauth2/token"
        case .flightStatus:
            return "/v2/schedule/flights"
        case .absolute:
            return ""
        }
    }
    
    /// The URL scheme used by the API (e.g., "https").
    var scheme: String { "https" }
    
    /// The host of the Rick and Morty API.
    var host: String { "test.api.amadeus.com" }
    
    /// Content-Type header for the endpoint
    var contentType: String? {
        switch self {
        case .oauth2Token:
            return "application/x-www-form-urlencoded"
        default:
            return nil
        }
    }
    
    /// HTTP method for the endpoint
    var method: String {
        switch self {
        case .oauth2Token:
            return "POST"
        default:
            return "GET"
        }
    }
    
    /// Query parameters for the endpoint
    var queryItems: [URLQueryItem]? {
        switch self {
        case .flightStatus(let flightNumber, let date):
            return [
                URLQueryItem(name: "carrierCode", value: String(flightNumber.prefix(2))),
                URLQueryItem(name: "flightNumber", value: String(flightNumber.dropFirst(2))),
                URLQueryItem(name: "scheduledDepartureDate", value: date)
            ]
            
        case .oauth2Token, .absolute:
            return nil
        }
    }
    
    /// Body for POST requests
    func body(clientId: String, clientSecret: String) -> Data? {
        switch self {
        case .oauth2Token:
            let bodyString = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)"
            return bodyString.data(using: .utf8)
        default:
            return nil
        }
    }
    
    var basePath: String { "" }
    
    /// Constructs a full `URL` for the selected endpoint.
    ///
    /// - Throws: `APIError.invalidURL` if the URL could not be constructed.
    /// - Returns: A valid `URL` ready for network requests.
    func asURL() throws -> URL {
        switch self {
        case .absolute(let url):
            guard let url else {
                throw APIError.invalidURL
            }
            return url
        default:
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = basePath + path
            components.queryItems = queryItems
            
            guard let url = components.url else {
                throw APIError.invalidURL
            }
            return url
        }
    }
    
    func asURLRequest(
        accessToken: String? = nil,
        clientId: String? = nil,
        clientSecret: String? = nil
    ) throws -> URLRequest {
        
        let url = try asURL()
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        if let accessToken, self != .oauth2Token {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        if self == .oauth2Token,
           let clientId = clientId,
           let clientSecret = clientSecret {
            request.httpBody = body(clientId: clientId, clientSecret: clientSecret)
        }
        
        return request
    }
}
