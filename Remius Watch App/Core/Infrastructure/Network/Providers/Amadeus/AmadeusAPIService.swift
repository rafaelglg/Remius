//
//  AmadeusAPIService.swift
//  Remius
//
//  Created by rafael.loggiodice on 4/1/26.
//

import Foundation

struct AmadeusAPIService: APIService {
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
        if let token = await tokenManager.getValidToken() {
            return token
        }

        return try await authenticate()
    }

    func authenticate() async throws -> String {
        let endpoint = AmadeusEndpoints.oauth2Token(clientId: clientId, clientSecret: clientSecret)
        let request = try endpoint.asURLRequest()

        let (data, response) = try await session.data(for: request)
        try HTTPResponseValidator.validate(response)
        let tokenResponse = try JSONDecoder().decode(AmadeusTokenResponse.self, from: data)

        await tokenManager.setToken(tokenResponse.accessToken, expiresIn: tokenResponse.expiresIn)
        return tokenResponse.accessToken
    }

    func fetch<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        do {
            return try await performRequest(endpoint: endpoint)
        } catch APIError.unauthorized {
            return try await reauthenticateAndRetry(endpoint: endpoint)
        }
    }

    // MARK: - Private

    private func performRequest<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        let token = try await getValidAccessToken()
        let request = try buildAuthorizedRequest(endpoint: endpoint, token: token)

        let (data, response) = try await session.data(for: request)
        try HTTPResponseValidator.validate(response)
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func reauthenticateAndRetry<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        await tokenManager.clearToken()
        let newToken = try await authenticate()
        let request = try buildAuthorizedRequest(endpoint: endpoint, token: newToken)

        let (data, response) = try await session.data(for: request)
        try HTTPResponseValidator.validate(response)
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func buildAuthorizedRequest(endpoint: APIEndpoint, token: String) throws -> URLRequest {
        var request = try endpoint.asURLRequest()
        request = AmadeusAuthInterceptor(token: token).intercept(request)
        return request
    }
}
