//
//  DatedFlight+Mock.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/1/26.
//

extension DatedFlight {
    static var mock: DatedFlight {
        return mocks[0]
    }

    static var mocks: [DatedFlight] {
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
