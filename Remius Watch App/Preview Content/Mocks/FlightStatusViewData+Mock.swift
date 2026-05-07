//
//  File.swift
//  Remius
//
//  Created by Rafael Loggiodice on 1/4/26.
//

extension FlightStatusViewData {
    static var mock: FlightStatusViewData {
        mocks[0]
    }

    static var empty: FlightStatusViewData {
        FlightStatusViewData(
            id: "",
            flightNumber: "",
            route: "",
            departureTime: "",
            arrivalTime: "",
            status: .pending,
            stopCities: [],
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
            // 0 — direct flight, on time
            FlightStatusViewData(
                id: "BA249-2026-04-15",
                flightNumber: "BA 249",
                route: "London → New York",
                departureTime: "14:30",
                arrivalTime: "18:45",
                status: .onTime,
                    stopCities: [],
                gate: "B23",
                terminal: "5",
                aircraftType: "733",
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

            // 1 — direct flight, delayed
            FlightStatusViewData(
                id: "IB6252-2026-04-15",
                flightNumber: "IB 6252",
                route: "Madrid → República Dominicana",
                departureTime: "09:15",
                arrivalTime: "10:30",
                status: .delayed,
                    stopCities: [],
                gate: "A12",
                terminal: "4",
                aircraftType: "320",
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

            // 2 — En vuelo, salió antes de hora
            FlightStatusViewData(
                id: "AF1259-2026-02-20",
                flightNumber: "AF 1259",
                route: "Rabat → Paris",
                departureTime: "14:10",
                arrivalTime: "17:10",
                status: .departed,
                    stopCities: [],
                gate: "K12",
                terminal: "2E",
                aircraftType: "320",
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

            // 3 — Cancelled
            FlightStatusViewData(
                id: "LH890-2026-04-20",
                flightNumber: "LH 890",
                route: "Frankfurt → São Paulo",
                departureTime: "22:00",
                arrivalTime: "06:30",
                status: .cancelled,
                    stopCities: [],
                gate: nil,
                terminal: "1",
                aircraftType: "32Q",
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

            // 4 — Pending (without gate)
            FlightStatusViewData(
                id: "EK241-2026-05-10",
                flightNumber: "EK 241",
                route: "Dubai → New York",
                departureTime: "08:15",
                arrivalTime: "14:45",
                status: .pending,
                    stopCities: [],
                gate: nil,
                terminal: nil,
                aircraftType: "77W",
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

            // 5 — landed, with baggage claim
            FlightStatusViewData(
                id: "UA900-2026-04-15",
                flightNumber: "UA 900",
                route: "San Francisco → Tokyo",
                departureTime: "11:00",
                arrivalTime: "15:30",
                status: .landed,
                    stopCities: [],
                gate: "G98",
                terminal: "I",
                aircraftType: "788",
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
            ),

            // 6 Multi-leg (BA249: London → Rio → London → Buenos Aires)
            FlightStatusViewData(
                id: "BA249-2026-04-01",
                flightNumber: "BA 249",
                route: "London → Rio de Janeiro → Buenos Aires",
                departureTime: "21:45",
                arrivalTime: "14:45",
                status: .onTime,
                stopCities: ["Rio de Janeiro", "London"],
                gate: "B32",
                terminal: "5",
                aircraftType: "777",
                duration: "14h 30m",
                legs: [
                    FlightLegViewData(
                        id: 0,
                        origin: "LHR",
                        destination: "GIG",
                        duration: "11h 20m",
                        aircraftType: "777"
                    ),
                    FlightLegViewData(
                        id: 1,
                        origin: "LHR",
                        destination: "GIG",
                        duration: "11h 20m",
                        aircraftType: "777"
                    ),
                    FlightLegViewData(
                        id: 2,
                        origin: "GIG",
                        destination: "EZE",
                        duration: "3h 10m",
                        aircraftType: "200"
                    )
                ],
                departureDelayMinutes: 0,
                arrivalDelayMinutes: 0,
                progressPercent: 0,
                cruisingSpeed: "819 km/h",
                cruisingAltitude: nil,
                baggageClaim: nil,
                originCode: "LHR",
                originCity: "London",
                destinationCode: "EZE",
                destinationCity: "Buenos Aires"
            )
        ]
    }
}
