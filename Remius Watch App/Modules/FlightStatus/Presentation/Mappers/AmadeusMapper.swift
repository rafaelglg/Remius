//
//  AmadeusMapper.swift
//  Remius
//
//  Created by Rafael Loggiodice on 18/2/26.
//

import Foundation

// Modules/FlightStatus/Presentation/Mappers/AmadeusMapper.swift

protocol AmadeusMapperProtocol {
    func map(_ flight: DatedFlight) -> FlightStatusViewData
}

struct AmadeusMapper: AmadeusMapperProtocol {

    func map(_ flight: DatedFlight) -> FlightStatusViewData {
        let origin = flight.flightPoints.first?.iataCode ?? "???"
        let destination = flight.flightPoints.last?.iataCode ?? "???"

        let departureTimeValue = flight.flightPoints.first?.departure?.timings
            .first(where: { $0.qualifier == "STD" })?.value ?? ""
        let arrivalTimeValue = flight.flightPoints.last?.arrival?.timings
            .first(where: { $0.qualifier == "STA" })?.value ?? ""

        let depTime = extractTime(from: departureTimeValue)
        let arrTime = extractTime(from: arrivalTimeValue)

        let numberOfStops = max(0, flight.legs.count - 1)
        let stopCity = numberOfStops > 0 ? flight.legs.first?.offPointIataCode : nil

        let operatingFlight = flight.segments.first?.partnership?.operatingFlight
        let operatingFlightNumber = operatingFlight.map {
            "\($0.carrierCode) \($0.flightNumber)"
        }

        let legsData = mapLegs(flight.legs)
        let aircraftType = mapAircraftType(flight.legs.first?.aircraftEquipment?.aircraftType)
        let duration = formatDuration(flight.segments.first?.scheduledSegmentDuration ?? "")
        let status = determineStatus(from: flight.flightPoints.first?.departure)

        let gate = flight.flightPoints.first?.departure?.gate?.mainGate
        let terminal = flight.flightPoints.first?.departure?.terminal?.code

        let departureDelay = calculateDelay(from: flight.flightPoints.first?.departure)
        let arrivalDelay = calculateDelay(from: flight.flightPoints.last?.arrival)

        return FlightStatusViewData(
            id: "\(flight.flightDesignator.carrierCode)\(flight.flightDesignator.flightNumber)-\(flight.scheduledDepartureDate)",
            flightNumber: "\(flight.flightDesignator.carrierCode) \(flight.flightDesignator.flightNumber)",
            operatingFlightNumber: operatingFlightNumber,
            route: "\(origin) → \(destination)",
            departureTime: depTime,
            arrivalTime: arrTime,
            status: status,
            stops: numberOfStops,
            stopCity: stopCity,
            gate: gate,
            terminal: terminal,
            aircraftType: aircraftType,
            duration: duration,
            legs: legsData,
            departureDelayMinutes: departureDelay,
            arrivalDelayMinutes: arrivalDelay,
            progressPercent: 0,
            cruisingSpeed: nil,
            cruisingAltitude: nil,
            baggageClaim: nil,
            originCode: origin,
            originCity: nil,
            destinationCode: destination,
            destinationCity: nil
        )
    }

    // MARK: - Private Helpers

    private func mapLegs(_ legs: [FlightLeg]) -> [FlightLegViewData] {
        legs.enumerated().map { index, leg in
            let aircraft = mapAircraftType(leg.aircraftEquipment?.aircraftType)
            return FlightLegViewData(
                id: "\(leg.boardPointIataCode)-\(leg.offPointIataCode)-\(index)",
                origin: leg.boardPointIataCode,
                destination: leg.offPointIataCode,
                duration: formatDuration(leg.scheduledLegDuration),
                aircraftType: aircraft
            )
        }
    }

    private func mapAircraftType(_ code: String?) -> String? {
        guard let code else { return nil }
        return AircraftType(iataCode: code).displayName
    }

    private func determineStatus(from departure: DepartureArrival?) -> FlightStatus {
        guard let departure else { return .pending }

        if departure.timings.contains(where: { $0.qualifier == "ATD" }) {
            return .departed
        }

        let scheduledTime = departure.timings.first(where: { $0.qualifier == "STD" })
        let estimatedTime = departure.timings.first(where: { $0.qualifier == "ETD" })

        if let estimated = estimatedTime?.value,
           let scheduled = scheduledTime?.value,
           estimated != scheduled {
            return .delayed
        }

        return .onTime
    }

    private func calculateDelay(from departureArrival: DepartureArrival?) -> Int {
        guard let timing = departureArrival?.timings.first(where: { $0.qualifier == "STD" || $0.qualifier == "ETD" || $0.qualifier == "STA" || $0.qualifier == "ETA" }),
              let delays = timing.delays,
              let firstDelay = delays.first else {
            return 0
        }

        let cleaned = firstDelay.duration.replacingOccurrences(of: "PT", with: "").replacingOccurrences(of: "M", with: "")
        return Int(cleaned) ?? 0
    }

    private func extractTime(from isoString: String) -> String {
        // "2026-02-21T14:10:00Z" → "14:10"
        guard let tIndex = isoString.firstIndex(of: "T") else { return "--:--" }
        let timeStart = isoString.index(after: tIndex)
        let timePart = String(isoString[timeStart...])
        return String(timePart.prefix(5))
    }

    private func formatDuration(_ duration: String) -> String {
        let cleaned = duration.replacingOccurrences(of: "PT", with: "")

        if cleaned.contains("H") {
            let parts = cleaned.components(separatedBy: "H")
            let hours = parts[0]

            if parts.count > 1 && !parts[1].isEmpty {
                let minutes = parts[1].replacingOccurrences(of: "M", with: "")
                return "\(hours)h \(minutes)m"
            }
            return "\(hours)h"
        }

        return cleaned.replacingOccurrences(of: "M", with: "m")
    }
}
