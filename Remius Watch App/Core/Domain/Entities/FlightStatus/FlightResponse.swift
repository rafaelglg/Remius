//
//  FlightResponse.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

struct FlightResponse: Codable {
    let data: [DatedFlight]
}

struct DatedFlight: Codable {
    let scheduledDepartureDate: String
    let flightDesignator: FlightDesignator
    let flightPoints: [FlightPoint]
    let segments: [FlightSegment]
    let legs: [FlightLeg]
}

struct FlightDesignator: Codable {
    let carrierCode: String
    let flightNumber: Int
}

struct FlightPoint: Codable {
    let iataCode: String
    let departure: DepartureArrival?
    let arrival: DepartureArrival?
}

struct DepartureArrival: Codable {
    let timings: [Timing]
}

struct Timing: Codable {
    let qualifier: String // "STD" para salida, "STA" para llegada
    let value: String     // La fecha y hora en formato ISO8601
}

struct FlightSegment: Codable {
    let boardPointIataCode: String
    let offPointIataCode: String
    let scheduledSegmentDuration: String // Formato "PT16H45M"
    let partnership: Partnership?
}

struct Partnership: Codable {
    let operatingFlight: FlightDesignator?
}

// 6. LEGS (La parte física: de dónde a dónde vuela el avión realmente)
struct FlightLeg: Codable {
    let boardPointIataCode: String
    let offPointIataCode: String
    let aircraftEquipment: AircraftEquipment?
    let scheduledLegDuration: String
}

struct AircraftEquipment: Codable {
    let aircraftType: String // Ej: "777"
}

extension DatedFlight {
    static var mockList: [DatedFlight] {
        return [
            DatedFlight(
                scheduledDepartureDate: "2026-01-15",
                flightDesignator: FlightDesignator(carrierCode: "IB", flightNumber: 6252),
                flightPoints: [
                    FlightPoint(
                        iataCode: "MAD",
                        departure: DepartureArrival(timings: [Timing(qualifier: "STD", value: "2026-01-15T12:00:00")]),
                        arrival: nil
                    ),
                    FlightPoint(
                        iataCode: "JFK",
                        departure: nil,
                        arrival: DepartureArrival(timings: [Timing(qualifier: "STA", value: "2026-01-15T20:00:00")])
                    )
                ],
                segments: [
                    FlightSegment(boardPointIataCode: "MAD", offPointIataCode: "JFK", scheduledSegmentDuration: "PT8H", partnership: nil)
                ],
                legs: [
                    FlightLeg(boardPointIataCode: "MAD", offPointIataCode: "JFK", aircraftEquipment: AircraftEquipment(aircraftType: "350"), scheduledLegDuration: "PT8H")
                ]
            )
        ]
    }
}
