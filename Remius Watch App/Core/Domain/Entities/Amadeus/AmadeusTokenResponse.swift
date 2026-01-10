//
//  AmadeusTokenResponse.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

struct AmadeusTokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
