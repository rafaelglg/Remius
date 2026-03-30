//
//  FlightAwareAuthInterceptor.swift
//  Remius
//
//  Created by Rafael Loggiodice on 17/2/26.
//

import Foundation

/// Interceptor responsible for adding FlightAware authentication headers.
struct FlightAwareAuthInterceptor: RequestInterceptor {
    private let apiKey: String

    init(config: FlightAwareConfig) {
        self.apiKey = config.apiKey
    }

    func intercept(_ request: URLRequest) -> URLRequest {
        var modifiedRequest = request
        modifiedRequest.setValue(apiKey, forHTTPHeaderField: "x-apikey")
        return modifiedRequest
    }
}
