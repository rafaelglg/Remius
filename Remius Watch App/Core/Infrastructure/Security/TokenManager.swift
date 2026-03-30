//
//  TokenManager.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

import Foundation

actor TokenManager {
    private var currentToken: String?
    private var expirationDate: Date?

    /// Renew 60 seconds before expiration to avoid failures due to network latency
    private let safetyBuffer: TimeInterval = 60

    func setToken(_ token: String, expiresIn: Int) {
        currentToken = token
        expirationDate = .now.adding(seconds: expiresIn)
    }

    func getValidToken() -> String? {
        guard let token = currentToken,
              let expiration = expirationDate,
              Date.now < expiration.subtracting(seconds: safetyBuffer) else {
            clearToken()
            return nil
        }
        return token
    }

    func clearToken() {
        currentToken = nil
        expirationDate = nil
    }
}

// MARK: - Date + Readability

private extension Date {
    nonisolated func adding(seconds: Int) -> Date {
        addingTimeInterval(TimeInterval(seconds))
    }

    nonisolated func subtracting(seconds: TimeInterval) -> Date {
        addingTimeInterval(-seconds)
    }
}
