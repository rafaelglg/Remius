//
//  APIEndpoint 2.swift
//  Remius
//
//  Created by Rafael Loggiodice on 16/2/26.
//

import Foundation

protocol APIEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem]? { get }
    var contentType: String? { get }
    var headers: [String: String] { get }
    var body: Data? { get }

    func asURLRequest() throws -> URLRequest
}

extension APIEndpoint {
    var scheme: String { "https" }
    var contentType: String? { nil }
    var headers: [String: String] { [:] }
    var body: Data? { nil }

    func asURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body

        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}
