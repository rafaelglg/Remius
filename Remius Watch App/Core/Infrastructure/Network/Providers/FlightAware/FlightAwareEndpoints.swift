//
//  FlightAwareEndpoints.swift
//  Remius
//
//  Created by Rafael Loggiodice on 16/2/26.
//

import Foundation

enum FlightAwareEndpoints: APIEndpoint {
    case flightStatus(flightNumber: String, date: String)

    var host: String { "aeroapi.flightaware.com" }
    var path: String {
        switch self {
        case let .flightStatus(flightNumber, _):
            return "/aeroapi/flights/\(flightNumber)"
        }
    }

    var method: String { "GET" }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .flightStatus(_, date):
            return [
                URLQueryItem(name: "ident_type", value: "designator"),
                URLQueryItem(name: "start", value: "\(date)T00:00:00Z"),
                URLQueryItem(name: "end", value: "\(date)T23:59:59Z"),
                URLQueryItem(name: "max_pages", value: "1")
            ]
        }
    }
}
