//
//  FlightAwareMapper.swift
//  Remius
//
//  Created by Rafael Loggiodice on 19/2/26.
//

import Foundation

protocol FlightAwareMapperProtocol {
    func map(_ group: FlightRouteGroup) -> FlightStatusViewData
}

struct FlightAwareMapper: FlightAwareMapperProtocol {

    func map(_ group: FlightRouteGroup) -> FlightStatusViewData {
        guard let departureFlight = group.departureFlight,
              let arrivalFlight = group.arrivalFlight else {
            return .empty
        }

        return FlightStatusViewData(
            id: makeId(from: departureFlight),
            flightNumber: departureFlight.identIata ?? "",
            operatingFlightNumber: nil,
            route: makeRoute(departure: departureFlight, arrival: arrivalFlight),
            departureTime: extractTime(from: departureFlight.scheduledOut),
            arrivalTime: extractTime(from: arrivalFlight.scheduledIn),
            status: mapStatus(from: departureFlight),
            stops: max(0, group.segments.count - 1),
            stopCity: group.stops.first,
            gate: departureFlight.gateOrigin,
            terminal: departureFlight.terminalOrigin,
            aircraftType: mapAircraftName(departureFlight.aircraftType),
            duration: formatDuration(seconds: departureFlight.filedEte ?? 0),
            legs: mapLegs(group.segments),
            departureDelayMinutes: (departureFlight.departureDelay ?? 0) / 60,
            arrivalDelayMinutes: (arrivalFlight.arrivalDelay ?? 0) / 60,
            progressPercent: departureFlight.progressPercent ?? 0,
            cruisingSpeed: formatSpeed(knots: departureFlight.filedAirspeed),
            cruisingAltitude: formatAltitude(hundredsFeet: departureFlight.filedAltitude),
            baggageClaim: departureFlight.baggageClaim,
            originCode: departureFlight.origin.codeIata ?? "???",
            originCity: departureFlight.origin.city,
            destinationCode: arrivalFlight.destination.codeIata ?? "???",
            destinationCity: arrivalFlight.destination.city
        )
    }
}

// MARK: - Identity & Route

private extension FlightAwareMapper {

    func makeId(from flight: FlightAwareFlightData) -> String {
        let number = flight.identIata ?? flight.ident
        let date = String(flight.scheduledOut?.prefix(10) ?? "")
        return "\(number)-\(date)"
    }

    func makeRoute(departure: FlightAwareFlightData, arrival: FlightAwareFlightData) -> String {
        let origin = departure.origin.city ?? departure.origin.codeIata ?? "???"
        let destination = arrival.destination.city ?? arrival.destination.codeIata ?? "???"
        return "\(origin) → \(destination)"
    }
}

// MARK: - Status Mapping

private extension FlightAwareMapper {

    func mapStatus(from flight: FlightAwareFlightData) -> FlightStatus {
        if flight.cancelled { return .cancelled }
        if flight.diverted { return .departed }

        if flight.actualOn != nil || flight.actualIn != nil { return .landed }

        let status = flight.status.lowercased()

        if status.contains("arrived") || status.contains("landed") { return .landed }

        if status.contains("en route") {
            return status.contains("delay") ? .delayed : .onTime
        }

        if status.contains("boarding") { return .boarding }
        if status.contains("delay") { return .delayed }
        if status.contains("scheduled") { return .pending }

        return .pending
    }
}

// MARK: - Legs

private extension FlightAwareMapper {

    func mapLegs(_ segments: [FlightAwareFlightData]) -> [FlightLegViewData] {
        segments.enumerated().map { index, segment in
            FlightLegViewData(
                id: "\(segment.origin.codeIata ?? "?")-\(segment.destination.codeIata ?? "?")-\(index)",
                origin: segment.origin.codeIata ?? "???",
                destination: segment.destination.codeIata ?? "???",
                duration: formatDuration(seconds: segment.filedEte ?? 0),
                aircraftType: mapAircraftName(segment.aircraftType)
            )
        }
    }
}

// MARK: - Formatters

private extension FlightAwareMapper {

    func mapAircraftName(_ code: String?) -> String? {
        guard let code else { return nil }
        return AircraftType(iataCode: code).displayName
    }

    func extractTime(from isoString: String?) -> String {
        guard let isoString, let tIndex = isoString.firstIndex(of: "T") else { return "--:--" }
        let timeStart = isoString.index(after: tIndex)
        return String(isoString[timeStart...].prefix(5))
    }

    func formatDuration(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours)h \(minutes)m"
    }

    func formatSpeed(knots: Int?) -> String? {
        guard let knots else { return nil }
        return "\(knots.knotsInKmh) km/h"
    }

    func formatAltitude(hundredsFeet: Int?) -> String? {
        guard let hundredsFeet else { return nil }
        return "\(hundredsFeet.hundredsFeetInMeters) m"
    }
}
