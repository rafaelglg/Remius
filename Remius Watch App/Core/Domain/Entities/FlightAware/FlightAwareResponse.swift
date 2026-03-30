//
//  FlightAwareResponse.swift
//  Remius
//
//  Created by Rafael Loggiodice on 17/2/26.
//

import Foundation

struct FlightAwareResponse: Codable {
    let flights: [FlightAwareFlightData]
}

// MARK: - FlightAwareFlightData

struct FlightAwareFlightData: Codable {

    // MARK: Identity
    let ident: String
    let identIcao: String?
    let identIata: String?
    let faFlightId: String
    let flightNumber: String?
    let operatorIata: String?
    let operatorIcao: String?
    let registration: String?
    let inboundFaFlightId: String?
    let codesharesIata: [String]

    // MARK: Status
    let status: String
    let progressPercent: Int?
    let diverted: Bool
    let cancelled: Bool

    // MARK: Route
    let origin: FlightAwareAirport
    let destination: FlightAwareAirport
    let routeDistance: Int?

    // MARK: Gate & Terminal
    let gateOrigin: String?
    let gateDestination: String?
    let terminalOrigin: String?
    let terminalDestination: String?
    let baggageClaim: String?

    // MARK: Times - Gate (out/in)
    let scheduledOut: String?
    let estimatedOut: String?
    let actualOut: String?
    let scheduledIn: String?
    let estimatedIn: String?
    let actualIn: String?

    // MARK: Times - Runway (off/on)
    let scheduledOff: String?
    let estimatedOff: String?
    let actualOff: String?
    let scheduledOn: String?
    let estimatedOn: String?
    let actualOn: String?

    // MARK: Delay
    let departureDelay: Int?
    let arrivalDelay: Int?

    // MARK: Flight Info
    let aircraftType: String?
    let filedEte: Int?
    let filedAirspeed: Int?
    let filedAltitude: Int?

    // MARK: Type
    let type: FlightAwareFlightType?
}

// MARK: - FlightAwareAirport

struct FlightAwareAirport: Codable {
    let code: String?
    let codeIcao: String?
    let codeIata: String?
    let name: String?
    let city: String?
    let timezone: String?
}

// MARK: - FlightAwareFlightType

enum FlightAwareFlightType: String, Codable {
    case airline = "Airline"
    case generalAviation = "General_Aviation"
}
