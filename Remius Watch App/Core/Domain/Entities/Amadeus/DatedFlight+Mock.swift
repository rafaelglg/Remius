//
//  DatedFlight+Mock.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/1/26.
//

extension DatedFlight {
    static var mock: DatedFlight {
        mocks[0]
    }

    static var mocks: [DatedFlight] {
        [
            // Direct flight without delays
            DatedFlight(
                scheduledDepartureDate: "2026-01-15",
                flightDesignator: FlightDesignator(
                    carrierCode: "IB",
                    flightNumber: 6252
                ),
                flightPoints: [
                    FlightPoint(
                        iataCode: "MAD",
                        departure: DepartureArrival(
                            terminal: Terminal(code: "4"),
                            gate: Gate(mainGate: "A12"),
                            timings: [
                                Timing(
                                    qualifier: "STD",
                                    value: "2026-01-15T12:00:00+01:00",
                                    delays: nil
                                )
                            ]
                        ),
                        arrival: nil
                    ),
                    FlightPoint(
                        iataCode: "JFK",
                        departure: nil,
                        arrival: DepartureArrival(
                            terminal: Terminal(code: "1"),
                            gate: Gate(mainGate: "B23"),
                            timings: [
                                Timing(
                                    qualifier: "STA",
                                    value: "2026-01-15T20:00:00-05:00",
                                    delays: nil
                                )
                            ]
                        )
                    )
                ],
                segments: [
                    FlightSegment(
                        boardPointIataCode: "MAD",
                        offPointIataCode: "JFK",
                        scheduledSegmentDuration: "PT8H",
                        partnership: nil
                    )
                ],
                legs: [
                    FlightLeg(
                        boardPointIataCode: "MAD",
                        offPointIataCode: "JFK",
                        aircraftEquipment: AircraftEquipment(aircraftType: "350"),
                        scheduledLegDuration: "PT8H"
                    )
                ]
            ),

            // Flight with 25-minute delay and codeshare
            DatedFlight(
                scheduledDepartureDate: "2026-02-21",
                flightDesignator: FlightDesignator(
                    carrierCode: "AF",
                    flightNumber: 1259
                ),
                flightPoints: [
                    FlightPoint(
                        iataCode: "RBA",
                        departure: DepartureArrival(
                            terminal: nil,
                            gate: nil,
                            timings: [
                                Timing(
                                    qualifier: "STD",
                                    value: "2026-02-21T14:10:00Z",
                                    delays: [
                                        Delay(duration: "PT25M")  // 25 minutes delay
                                    ]
                                ),
                                Timing(
                                    qualifier: "ETD",
                                    value: "2026-02-21T14:35:00Z",  // Estimated departure with delay
                                    delays: nil
                                )
                            ]
                        ),
                        arrival: nil
                    ),
                    FlightPoint(
                        iataCode: "CDG",
                        departure: nil,
                        arrival: DepartureArrival(
                            terminal: Terminal(code: "2E"),
                            gate: nil,
                            timings: [
                                Timing(
                                    qualifier: "STA",
                                    value: "2026-02-21T17:10:00+01:00",
                                    delays: nil
                                )
                            ]
                        )
                    )
                ],
                segments: [
                    FlightSegment(
                        boardPointIataCode: "RBA",
                        offPointIataCode: "CDG",
                        scheduledSegmentDuration: "PT2H",
                        partnership: Partnership(
                            operatingFlight: FlightDesignator(
                                carrierCode: "KL",
                                flightNumber: 2193
                            )
                        )
                    )
                ],
                legs: [
                    FlightLeg(
                        boardPointIataCode: "RBA",
                        offPointIataCode: "CDG",
                        aircraftEquipment: AircraftEquipment(aircraftType: "320"),
                        scheduledLegDuration: "PT2H"
                    )
                ]
            ),

            // Flight with one stop (2 legs) and codeshare
            DatedFlight(
                scheduledDepartureDate: "2026-03-10",
                flightDesignator: FlightDesignator(
                    carrierCode: "AA",
                    flightNumber: 1234
                ),
                flightPoints: [
                    FlightPoint(
                        iataCode: "LAX",
                        departure: DepartureArrival(
                            terminal: Terminal(code: "8"),
                            gate: Gate(mainGate: "C45"),
                            timings: [
                                Timing(
                                    qualifier: "STD",
                                    value: "2026-03-10T11:00:00-08:00",
                                    delays: nil
                                )
                            ]
                        ),
                        arrival: nil
                    ),
                    FlightPoint(
                        iataCode: "MIA",
                        departure: nil,
                        arrival: DepartureArrival(
                            terminal: Terminal(code: "D"),
                            gate: Gate(mainGate: "D12"),
                            timings: [
                                Timing(
                                    qualifier: "STA",
                                    value: "2026-03-10T19:20:00-05:00",
                                    delays: nil
                                )
                            ]
                        )
                    )
                ],
                segments: [
                    FlightSegment(
                        boardPointIataCode: "LAX",
                        offPointIataCode: "MIA",
                        scheduledSegmentDuration: "PT5H20M",
                        partnership: Partnership(
                            operatingFlight: FlightDesignator(
                                carrierCode: "BA",
                                flightNumber: 4567
                            )
                        )
                    )
                ],
                legs: [
                    FlightLeg(
                        boardPointIataCode: "LAX",
                        offPointIataCode: "DFW",
                        aircraftEquipment: AircraftEquipment(aircraftType: "738"),
                        scheduledLegDuration: "PT2H45M"
                    ),
                    FlightLeg(
                        boardPointIataCode: "DFW",
                        offPointIataCode: "MIA",
                        aircraftEquipment: AircraftEquipment(aircraftType: "788"),
                        scheduledLegDuration: "PT2H35M"
                    )
                ]
            )
        ]
    }
}
