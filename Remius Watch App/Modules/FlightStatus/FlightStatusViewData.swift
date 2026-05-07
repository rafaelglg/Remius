//
//  FlightStatusViewData.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/1/26.
//

import Foundation
import SwiftUI

struct FlightStatusViewData: Identifiable, Hashable {
    let id: String
    let flightNumber: String
    let route: String
    let departureTime: String
    let arrivalTime: String
    let status: FlightStatus
    let stopCities: [String]
    let gate: String?
    let terminal: String?
    let aircraftType: String?
    let duration: String
    let legs: [FlightLegViewData]
    let departureDelayMinutes: Int
    let arrivalDelayMinutes: Int
    let progressPercent: Int
    let cruisingSpeed: String?
    let cruisingAltitude: String?
    let baggageClaim: String?
    let originCode: String
    let originCity: String?
    let destinationCode: String
    let destinationCity: String?

    // MARK: - Computed Properties

    var statusText: LocalizedStringResource {
        status.localizedText
    }

    var routeInfo: RouteInfo {
        let stops: [StopInfo] = legs.dropLast().enumerated().map { index, leg in
            let city = index < stopCities.count ? stopCities[index] : nil
            return StopInfo(id: index, code: leg.destination, city: city)
        }

        return RouteInfo(
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            originCity: originCity,
            originCode: originCode,
            destinationCity: destinationCity,
            destinationCode: destinationCode,
            stops: stops
        )
    }

    var routeCodes: String {
        guard !legs.isEmpty else {
            return "\(originCode) → \(destinationCode)"
        }
        // LHR → GIG → EZE
        let codes = [legs.first?.origin].compactMap { $0 } + legs.map(\.destination)
        return codes.joined(separator: " → ")
    }

    var routeCities: String? {
        guard let originCity, let destinationCity else { return nil }
        guard !stopCities.isEmpty else {
            return "\(originCity) → \(destinationCity)"
        }
        // London → Rio de Janeiro → Buenos Aires
        let cities = [originCity] + stopCities + [destinationCity]
        return cities.joined(separator: " → ")
    }

    var isDirectFlight: Bool {
        stopCities.isEmpty
    }

    // MARK: Delay

    var hasDelays: Bool {
        departureDelayMinutes != .zero || arrivalDelayMinutes != .zero
    }

    var isEarly: Bool {
        departureDelayMinutes < .zero
    }

    var delayText: String? {
        guard departureDelayMinutes != .zero else { return nil }
        let prefix = departureDelayMinutes < .zero ? "-" : "+"
        return "\(prefix)\(abs(departureDelayMinutes))m"
    }

    var arrivalDelayText: String? {
        guard arrivalDelayMinutes != .zero else { return nil }
        let prefix = arrivalDelayMinutes < .zero ? "-" : "+"
        return "\(prefix)\(abs(arrivalDelayMinutes))m"
    }

    // MARK: Progress

    var isInProgress: Bool {
        progressPercent > .zero && progressPercent < 100
    }

    var progressValue: Double {
        Double(progressPercent) / 100.0
    }

    // MARK: Airport

    var gateInfo: String? {
        guard let gate else { return nil }
        if let terminal {
            return "T\(terminal) • Gate \(gate)"
        }
        return "Gate \(gate)"
    }

    var hasAirportInfo: Bool {
        gateInfo != nil || baggageClaim != nil
    }

    var hasAviationInfo: Bool {
        cruisingSpeed != nil || cruisingAltitude != nil
    }

    // MARK: - Static Helpers

    static func navigationTitle(count: Int) -> String {
        guard count > .zero else { return "" }
        return String(localized: "\(count) flight.status.navigation.title")
    }

    static var addFlightLabel: LocalizedStringResource {
        "flight.status.action.addFlight"
    }

    static var reloadLabel: LocalizedStringResource {
        "flight.status.action.reloadFlights"
    }
}

struct FlightLegViewData: Identifiable, Hashable {
    let id: Int
    let origin: String
    let destination: String
    let duration: String
    let aircraftType: String?
}

enum FlightStatus: Equatable, CaseIterable {
    case onTime
    case delayed
    case cancelled
    case boarding
    case departed
    case landed
    case pending

    var color: Color {
        switch self {
        case .onTime: .green
        case .delayed: .orange
        case .cancelled: .red
        case .boarding: .blue
        case .departed: .gray
        case .landed: .green
        case .pending: .yellow
        }
    }

    var localizedText: LocalizedStringResource {
        switch self {
        case .onTime: "flight.status.onTime"
        case .delayed: "flight.status.delayed"
        case .cancelled: "flight.status.cancelled"
        case .boarding: "flight.status.boarding"
        case .departed: "flight.status.departed"
        case .landed: "flight.status.landed"
        case .pending: "flight.status.pending"
        }
    }
}
