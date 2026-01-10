//
//  AmadeusTokenResponse.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

struct AmadeusTokenResponse: Codable {
    let clientId: String
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let state: String

    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case state
    }

    static var mock: AmadeusTokenResponse {
        mocks[0]
    }

    static var mocks: [AmadeusTokenResponse] = [
        AmadeusTokenResponse(
            clientId: "123",
            accessToken: "accessToken",
            tokenType: "Token type",
            expiresIn: 12000,
            state: "approved"
        )
    ]
}
