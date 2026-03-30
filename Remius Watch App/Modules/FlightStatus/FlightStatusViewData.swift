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
    let operatingFlightNumber: String?
    let route: String
    let departureTime: String
    let arrivalTime: String
    let status: FlightStatus
    let stops: Int
    let stopCity: String?
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
        RouteInfo(
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            originCity: originCity,
            originCode: originCode,
            destinationCity: destinationCity,
            destinationCode: destinationCode
        )
    }

    var isDirectFlight: Bool {
        stops == .zero
    }

    var hasCodeshare: Bool {
        operatingFlightNumber != nil && operatingFlightNumber != flightNumber
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

    // MARK: Stops

    var stopsCountLocalized: LocalizedStringResource {
        stops == 1
            ? "flight.detail.oneStop"
            : "flight.detail.multipleStops \(stops)"
    }

    // MARK: - Static Helpers

    static func navigationTitle(count: Int) -> String {
        guard count > .zero else { return "" }
        return String(localized: "\(count) flight.status.navigation.title")
    }

    static var addFlightLabel: LocalizedStringResource {
        "flight.status.action.addFlight"
    }
}

struct FlightLegViewData: Identifiable, Hashable {
    let id: String
    let origin: String
    let destination: String
    let duration: String
    let aircraftType: String?
}

// MARK: - Mocks

extension FlightStatusViewData {
    static var mock: FlightStatusViewData {
        mocks[0]
    }

    static var empty: FlightStatusViewData {
        FlightStatusViewData(
            id: "",
            flightNumber: "",
            operatingFlightNumber: nil,
            route: "",
            departureTime: "",
            arrivalTime: "",
            status: .pending,
            stops: 0,
            stopCity: nil,
            gate: nil,
            terminal: nil,
            aircraftType: nil,
            duration: "",
            legs: [],
            departureDelayMinutes: 0,
            arrivalDelayMinutes: 0,
            progressPercent: 0,
            cruisingSpeed: nil,
            cruisingAltitude: nil,
            baggageClaim: nil,
            originCode: "",
            originCity: nil,
            destinationCode: "",
            destinationCity: nil
        )
    }

    static var mocks: [FlightStatusViewData] {
        [
            // 0 — Vuelo directo, a tiempo
            FlightStatusViewData(
                id: "BA249-2026-04-15",
                flightNumber: "BA 249",
                operatingFlightNumber: nil,
                route: "London → New York",
                departureTime: "14:30",
                arrivalTime: "18:45",
                status: .onTime,
                stops: 0,
                stopCity: nil,
                gate: "B23",
                terminal: "5",
                aircraftType: "Boeing 777-200",
                duration: "7h 15m",
                legs: [],
                departureDelayMinutes: 0,
                arrivalDelayMinutes: 0,
                progressPercent: 0,
                cruisingSpeed: "907 km/h",
                cruisingAltitude: "10668 m",
                baggageClaim: nil,
                originCode: "LHR",
                originCity: "London",
                destinationCode: "JFK",
                destinationCity: "New York"
            ),

            // 1 — Vuelo directo, retrasado
            FlightStatusViewData(
                id: "IB6252-2026-04-15",
                flightNumber: "IB 6252",
                operatingFlightNumber: nil,
                route: "Madrid → Barcelona",
                departureTime: "09:15",
                arrivalTime: "10:30",
                status: .delayed,
                stops: 0,
                stopCity: nil,
                gate: "A12",
                terminal: "4",
                aircraftType: "Airbus A320",
                duration: "1h 15m",
                legs: [],
                departureDelayMinutes: 15,
                arrivalDelayMinutes: 12,
                progressPercent: 0,
                cruisingSpeed: nil,
                cruisingAltitude: nil,
                baggageClaim: nil,
                originCode: "MAD",
                originCity: "Madrid",
                destinationCode: "BCN",
                destinationCity: "Barcelona"
            ),

            // 2 — Con escala + codeshare, embarcando
            FlightStatusViewData(
                id: "AA1234-2026-04-15",
                flightNumber: "AA 1234",
                operatingFlightNumber: "BA 4567",
                route: "Los Angeles → Miami",
                departureTime: "11:00",
                arrivalTime: "19:20",
                status: .boarding,
                stops: 1,
                stopCity: "DFW",
                gate: "C45",
                terminal: "8",
                aircraftType: "Boeing 787-8",
                duration: "5h 20m",
                legs: [
                    FlightLegViewData(
                        id: "LAX-DFW-0",
                        origin: "LAX",
                        destination: "DFW",
                        duration: "2h 45m",
                        aircraftType: "Boeing 737-800"
                    ),
                    FlightLegViewData(
                        id: "DFW-MIA-1",
                        origin: "DFW",
                        destination: "MIA",
                        duration: "2h 35m",
                        aircraftType: "Boeing 787-8"
                    )
                ],
                departureDelayMinutes: 0,
                arrivalDelayMinutes: 0,
                progressPercent: 0,
                cruisingSpeed: nil,
                cruisingAltitude: nil,
                baggageClaim: nil,
                originCode: "LAX",
                originCity: "Los Angeles",
                destinationCode: "MIA",
                destinationCity: "Miami"
            ),

            // 3 — En vuelo, salió antes de hora
            FlightStatusViewData(
                id: "AF1259-2026-02-20",
                flightNumber: "AF 1259",
                operatingFlightNumber: nil,
                route: "Rabat → Paris",
                departureTime: "14:10",
                arrivalTime: "17:10",
                status: .departed,
                stops: 0,
                stopCity: nil,
                gate: "K12",
                terminal: "2E",
                aircraftType: "Airbus A320",
                duration: "2h",
                legs: [],
                departureDelayMinutes: -5,
                arrivalDelayMinutes: 0,
                progressPercent: 45,
                cruisingSpeed: "833 km/h",
                cruisingAltitude: "10058 m",
                baggageClaim: nil,
                originCode: "RBA",
                originCity: "Rabat",
                destinationCode: "CDG",
                destinationCity: "Paris"
            ),

            // 4 — Cancelado
            FlightStatusViewData(
                id: "LH890-2026-04-20",
                flightNumber: "LH 890",
                operatingFlightNumber: nil,
                route: "Frankfurt → São Paulo",
                departureTime: "22:00",
                arrivalTime: "06:30",
                status: .cancelled,
                stops: 0,
                stopCity: nil,
                gate: nil,
                terminal: "1",
                aircraftType: "Airbus A340-300",
                duration: "11h 30m",
                legs: [],
                departureDelayMinutes: 0,
                arrivalDelayMinutes: 0,
                progressPercent: 0,
                cruisingSpeed: nil,
                cruisingAltitude: nil,
                baggageClaim: nil,
                originCode: "FRA",
                originCity: "Frankfurt",
                destinationCode: "GRU",
                destinationCity: "São Paulo"
            ),

            // 5 — Pendiente/programado (sin gate aún)
            FlightStatusViewData(
                id: "EK241-2026-05-10",
                flightNumber: "EK 241",
                operatingFlightNumber: nil,
                route: "Dubai → New York",
                departureTime: "08:15",
                arrivalTime: "14:45",
                status: .pending,
                stops: 0,
                stopCity: nil,
                gate: nil,
                terminal: nil,
                aircraftType: "Boeing 777-300ER",
                duration: "14h 30m",
                legs: [],
                departureDelayMinutes: 0,
                arrivalDelayMinutes: 0,
                progressPercent: 0,
                cruisingSpeed: nil,
                cruisingAltitude: nil,
                baggageClaim: nil,
                originCode: "DXB",
                originCity: "Dubai",
                destinationCode: "JFK",
                destinationCity: "New York"
            ),

            // 6 — Aterrizado, con baggage claim
            FlightStatusViewData(
                id: "UA900-2026-04-15",
                flightNumber: "UA 900",
                operatingFlightNumber: nil,
                route: "San Francisco → Tokyo",
                departureTime: "11:00",
                arrivalTime: "15:30",
                status: .landed,
                stops: 0,
                stopCity: nil,
                gate: "G98",
                terminal: "I",
                aircraftType: "Boeing 787-9",
                duration: "11h 30m",
                legs: [],
                departureDelayMinutes: 8,
                arrivalDelayMinutes: 3,
                progressPercent: 100,
                cruisingSpeed: "907 km/h",
                cruisingAltitude: "12496 m",
                baggageClaim: "5",
                originCode: "SFO",
                originCity: "San Francisco",
                destinationCode: "NRT",
                destinationCity: "Tokyo"
            )
        ]
    }
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
