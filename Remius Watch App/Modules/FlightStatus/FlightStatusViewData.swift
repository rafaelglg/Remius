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
    let departureDate: String
    let arrivalTime: String
    let arrivalDate: String
    let departureTimezone: String
    let arrivalTimezone: String
    let status: FlightStatus
    let stops: Int
    let stopCity: String?
    let gate: String?
    let aircraftType: String?
    let duration: String
    let legs: [FlightLegViewData]

    var statusColor: Color {
        status.color
    }

    var isDirectFlight: Bool {
        stops == .zero
    }

    var statusText: LocalizedStringResource {
        status.localizedText
    }

    var hasCodeshare: Bool {
        operatingFlightNumber != nil && operatingFlightNumber != flightNumber
    }

    var arrivesNextDay: Bool {
        departureDate != arrivalDate
    }

    var stopsCount: String {
        "\(stops)"
    }

    static func navigationTitle(count: Int) -> String {
        guard count > 0 else { return "" }
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

// MARK: - Mapping
// TODO: Refactor when migrating to new API
extension DatedFlight {
    func toViewData() -> FlightStatusViewData {
        let origin = flightPoints.first?.iataCode ?? "???"
        let destination = flightPoints.last?.iataCode ?? "???"

        let departureTimeValue = flightPoints.first?.departure?.timings
            .first(where: { $0.qualifier == "STD" })?.value ?? ""
        let arrivalTimeValue = flightPoints.last?.arrival?.timings
            .first(where: { $0.qualifier == "STA" })?.value ?? ""

        // Parse dates and timezones
        let (depTime, depDate, depTZ) = parseDateTime(departureTimeValue)
        let (arrTime, arrDate, arrTZ) = parseDateTime(arrivalTimeValue)

        // Calculate stops
        let numberOfStops = max(0, legs.count - 1)
        let stopCity = numberOfStops > 0 ? legs.first?.offPointIataCode : nil

        // Operating airline (codeshare)
        let operatingFlight = segments.first?.partnership?.operatingFlight
        let operatingFlightNumber = operatingFlight.map {
            "\($0.carrierCode) \($0.flightNumber)"
        }

        // Build legs data
        let legsData = legs.enumerated().map { index, leg in
            let aircraftCode = leg.aircraftEquipment?.aircraftType
            let aircraft = aircraftCode.map { AircraftType(iataCode: $0).displayName }

            return FlightLegViewData(
                id: "\(leg.boardPointIataCode)-\(leg.offPointIataCode)-\(index)",
                origin: leg.boardPointIataCode,
                destination: leg.offPointIataCode,
                duration: formatDuration(leg.scheduledLegDuration),
                aircraftType: aircraft
            )
        }

        let aircraftType: String? = {
            guard let code = legs.first?.aircraftEquipment?.aircraftType else { return nil }
            return AircraftType(iataCode: code).displayName
        }()

        let duration = formatDuration(segments.first?.scheduledSegmentDuration ?? "")
        let status = determineStatus()

        return FlightStatusViewData(
            id: "\(flightDesignator.carrierCode)\(flightDesignator.flightNumber)-\(scheduledDepartureDate)",
            flightNumber: "\(flightDesignator.carrierCode) \(flightDesignator.flightNumber)",
            operatingFlightNumber: operatingFlightNumber,
            route: "\(origin) → \(destination)",
            departureTime: depTime,
            departureDate: depDate,
            arrivalTime: arrTime,
            arrivalDate: arrDate,
            departureTimezone: depTZ,
            arrivalTimezone: arrTZ,
            status: status,
            stops: numberOfStops,
            stopCity: stopCity,
            gate: nil,
            aircraftType: aircraftType,
            duration: duration,
            legs: legsData
        )
    }

    // MARK: - Private Helpers

    private func determineStatus() -> FlightStatus {
        guard let departure = flightPoints.first?.departure else {
            return .pending
        }

        let scheduledTime = departure.timings.first(where: { $0.qualifier == "STD" })
        let estimatedTime = departure.timings.first(where: { $0.qualifier == "ETD" })

        if let estimated = estimatedTime?.value, let scheduled = scheduledTime?.value {
            return estimated != scheduled ? .delayed : .onTime
        }

        return .onTime
    }

    private func parseDateTime(_ isoString: String) -> (time: String, date: String, timezone: String) {
        // "2026-04-15T21:55+01:00"
        let components = isoString.split(separator: "T")
        guard components.count == 2 else {
            return ("--:--", "", "")
        }

        let datePart = String(components[0])
        let timePart = String(components[1])

        // Extract time (21:55)
        let time = String(timePart.prefix(5))

        // Extract timezone (+01:00)
        let tzStart = timePart.firstIndex(where: { $0 == "+" || $0 == "-" }) ?? timePart.endIndex
        let timezone = String(timePart[tzStart...])

        // Format date (Apr 15)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: datePart) {
            dateFormatter.dateFormat = "MMM d"
            return (time, dateFormatter.string(from: date), timezone)
        }

        return (time, datePart, timezone)
    }

    private func formatTime(_ isoTime: String) -> String {
        let components = isoTime.split(separator: "T")
        guard components.count > 1 else { return isoTime }
        return String(components[1].prefix(5))
    }

    private func formatDuration(_ duration: String) -> String {
        let cleaned = duration.replacingOccurrences(of: "PT", with: "")
        let components = cleaned.components(separatedBy: "H")

        guard components.count == 2 else { return duration }

        let hours = components[0]
        let minutes = components[1].replacingOccurrences(of: "M", with: "")

        return "\(hours)h \(minutes)m"
    }
}

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
            departureDate: "",
            arrivalTime: "",
            arrivalDate: "",
            departureTimezone: "",
            arrivalTimezone: "",
            status: .cancelled,
            stops: 0,
            stopCity: nil,
            gate: nil,
            aircraftType: nil,
            duration: "",
            legs: []
        )
    }

    static var mocks: [FlightStatusViewData] {
        [
            FlightStatusViewData(
                id: "BA249-2026-04-15",
                flightNumber: "BA 249",
                operatingFlightNumber: nil,
                route: "LHR → JFK",
                departureTime: "14:30",
                departureDate: "Apr 15",
                arrivalTime: "18:45",
                arrivalDate: "Apr 15",
                departureTimezone: "+00:00",
                arrivalTimezone: "-05:00",
                status: .onTime,
                stops: 0,
                stopCity: nil,
                gate: "B23",
                aircraftType: "777",
                duration: "7h 15m",
                legs: []
            ),
            FlightStatusViewData(
                id: "IB6252-2026-04-15",
                flightNumber: "IB 6252",
                operatingFlightNumber: nil,
                route: "MAD → BCN",
                departureTime: "09:15",
                departureDate: "Apr 15",
                arrivalTime: "10:30",
                arrivalDate: "Apr 15",
                departureTimezone: "+01:00",
                arrivalTimezone: "+01:00",
                status: .delayed,
                stops: 0,
                stopCity: nil,
                gate: "A12",
                aircraftType: "320",
                duration: "1h 15m",
                legs: []
            ),
            FlightStatusViewData(
                id: "AA1234-2026-04-15",
                flightNumber: "AA 1234",
                operatingFlightNumber: "BA 4567",
                route: "LAX → MIA",
                departureTime: "11:00",
                departureDate: "Apr 15",
                arrivalTime: "19:20",
                arrivalDate: "Apr 15",
                departureTimezone: "-08:00",
                arrivalTimezone: "-05:00",
                status: .boarding,
                stops: 1,
                stopCity: "DFW",
                gate: "C45",
                aircraftType: "787",
                duration: "5h 20m",
                legs: [
                    FlightLegViewData(
                        id: "LAX-DFW-0",
                        origin: "LAX",
                        destination: "DFW",
                        duration: "2h 45m",
                        aircraftType: "737"
                    ),
                    FlightLegViewData(
                        id: "DFW-MIA-1",
                        origin: "DFW",
                        destination: "MIA",
                        duration: "2h 35m",
                        aircraftType: "787"
                    )
                ]
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
    case pending

    var color: Color {
        switch self {
        case .onTime: .green
        case .delayed: .orange
        case .cancelled: .red
        case .boarding: .blue
        case .departed: .gray
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
        case .pending: "flight.status.pending"
        }
    }
}
