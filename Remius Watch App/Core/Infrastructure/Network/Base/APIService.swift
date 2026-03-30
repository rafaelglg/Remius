//
//  APIService.swift
//  Remius
//
//  Created by Rafael Loggiodice on 19/2/26.
//

protocol APIService: Sendable {
    func fetch<T: Codable>(endpoint: APIEndpoint) async throws -> T
}
