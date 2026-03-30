//
//  FlightAwareAPIService.swift
//  Remius
//
//  Created by Rafael Loggiodice on 16/2/26.
//

import Foundation

struct FlightAwareAPIService: APIService {
    let session: URLSession
    private let interceptor: RequestInterceptor

    init(session: URLSession, config: FlightAwareConfig) {
        self.session = session
        self.interceptor = FlightAwareAuthInterceptor(config: config)
    }

    func fetch<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        var request = try endpoint.asURLRequest()
        request = interceptor.intercept(request)

        let (data, response) = try await session.data(for: request)
        try HTTPResponseValidator.validate(response)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
