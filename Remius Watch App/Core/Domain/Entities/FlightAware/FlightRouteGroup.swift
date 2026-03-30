//
//  FlightRouteGroup.swift
//  Remius
//
//  Created by Rafael Loggiodice on 19/2/26.
//

struct FlightRouteGroup {
    let segments: [FlightAwareFlightData]

    var origin: String {
        segments.first?.origin.codeIata ?? "???"
    }

    var destination: String {
        segments.last?.destination.codeIata ?? "???"
    }

    var stops: [String] {
        segments.dropLast().compactMap { $0.destination.codeIata }
    }

    var departureFlight: FlightAwareFlightData? {
        segments.first
    }

    var arrivalFlight: FlightAwareFlightData? {
        segments.last
    }
}
