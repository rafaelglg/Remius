//
//  AmadeusAuthInterceptor.swift
//  Remius
//
//  Created by Rafael Loggiodice on 17/2/26.
//

import Foundation

/// Interceptor responsible for adding Amadeus Bearer token authentication.
struct AmadeusAuthInterceptor: RequestInterceptor {
    private let token: String

    init(token: String) {
        self.token = token
    }

    func intercept(_ request: URLRequest) -> URLRequest {
        var modifiedRequest = request
        modifiedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return modifiedRequest
    }
}
