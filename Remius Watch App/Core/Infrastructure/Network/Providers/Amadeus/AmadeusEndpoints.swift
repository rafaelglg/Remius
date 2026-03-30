//
//  AmadeusEndpoints.swift
//  Remius
//
//  Created by Rafael Loggiodice on 16/2/26.
//

import Foundation

enum AmadeusEndpoints: APIEndpoint, Equatable {
    case oauth2Token(clientId: String, clientSecret: String)
    case flightStatus(flightNumber: String, date: String)

    var host: String { "test.api.amadeus.com" }

    var path: String {
        switch self {
        case .oauth2Token:
            return "/v1/security/oauth2/token"
        case .flightStatus:
            return "/v2/schedule/flights"
        }
    }

    var method: String {
        switch self {
        case .oauth2Token:
            return "POST"
        default:
            return "GET"
        }
    }

    var contentType: String? {
        switch self {
        case .oauth2Token:
            return "application/x-www-form-urlencoded"
        default:
            return nil
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .flightStatus(flightNumber, date):
            return [
                URLQueryItem(name: "carrierCode", value: String(flightNumber.prefix(2))),
                URLQueryItem(name: "flightNumber", value: String(flightNumber.dropFirst(2))),
                URLQueryItem(name: "scheduledDepartureDate", value: date)
            ]
        default:
            return nil
        }
    }

    var headers: [String: String] {
        switch self {
        case .oauth2Token:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case let .flightStatus(_, accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        }
    }

    var body: Data? {
        switch self {
        case let .oauth2Token(clientId, clientSecret):
            let bodyString = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)"
            return bodyString.data(using: .utf8)
        default:
            return nil
        }
    }
}
