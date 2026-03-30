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
    let terminal: Terminal?
    let gate: Gate?
    let timings: [Timing]
}

struct Terminal: Codable {
    let code: String
}

struct Gate: Codable {
    let mainGate: String
}

struct Timing: Codable {
    let qualifier: String      // STD, STA, ETD, ETA, ATD, ATA
    let value: String          // ISO 8601
    let delays: [Delay]?
}

struct Delay: Codable {
    let duration: String       // "PT25M"
}

struct FlightSegment: Codable {
    let boardPointIataCode: String
    let offPointIataCode: String
    let scheduledSegmentDuration: String
    let partnership: Partnership?
}

struct Partnership: Codable {
    let operatingFlight: FlightDesignator?
}

struct FlightLeg: Codable {
    let boardPointIataCode: String
    let offPointIataCode: String
    let aircraftEquipment: AircraftEquipment?
    let scheduledLegDuration: String
}

struct AircraftEquipment: Codable {
    let aircraftType: String
}
