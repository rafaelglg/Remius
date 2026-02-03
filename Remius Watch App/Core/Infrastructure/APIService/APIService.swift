//
//  APIService.swift
//  Remius
//
//  Created by rafael.loggiodice on 4/1/26.
//

import Foundation

protocol APIService: Sendable {
    func fetch<T: Codable>(endpoint: RemiusEndpoints) async throws -> T
}

struct APIServiceImpl: APIService {
    let session: URLSession
    let tokenManager: TokenManager
    private let clientId: String
    private let clientSecret: String

    init(session: URLSession,
         tokenManager: TokenManager,
         config: AmadeusConfig) {
        self.session = session
        self.tokenManager = tokenManager
        self.clientId = config.clientId
        self.clientSecret = config.clientSecret
    }

    private func getValidAccessToken() async throws -> String {
        if let token = await tokenManager.getToken() {
            return token
        }

        return try await authenticate()
    }

    func authenticate() async throws -> String {
        let endpoint = RemiusEndpoints.oauth2Token
        let request = try endpoint.asURLRequest(clientId: clientId, clientSecret: clientSecret)

        let (data, response) = try await session.data(for: request)
        try handleResponse(response: response)
        let tokenResponse = try JSONDecoder().decode(AmadeusTokenResponse.self, from: data)

        await tokenManager.setToken(tokenResponse.accessToken)
        return tokenResponse.accessToken
    }

    func fetch<T: Codable>(endpoint: RemiusEndpoints) async throws -> T {
        let token = try await getValidAccessToken()
        let request = try endpoint.asURLRequest(accessToken: token)

        let (data, response) = try await session.data(for: request)
        try handleResponse(response: response)
        let modelResponse = try JSONDecoder().decode(T.self, from: data)
        return modelResponse
    }

    /// Validates the HTTP response status code.
    ///
    /// - Parameter response: The URL response returned from the server.
    /// - Throws: `APIError.requestFailed` if the status code is not in the 2xx range.
    func handleResponse(response: URLResponse) throws(APIError) {
        guard let status = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError.serverError(statusCode: 0)
        }

        switch status {
        case 200 ... 299:
            return
        case 401:
            throw APIError.unauthorized
        case 404:
            throw APIError.itemNotFound
        default:
            throw APIError.serverError(statusCode: status)
        }
    }
}
