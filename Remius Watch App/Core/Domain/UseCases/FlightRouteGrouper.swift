//
//  FlightRouteGrouper.swift
//  Remius
//
//  Created by Rafael Loggiodice on 27/2/26.
//

struct FlightRouteGrouper {

    func group(flights: [FlightAwareFlightData], for date: String) -> [FlightRouteGroup] {
        let chainStarts = flights.filter { isChainStart(flight: $0, date: date, allFlights: flights) }
        return chainStarts.map { buildChain(from: $0, allFlights: flights) }
    }

    private func isChainStart(
        flight: FlightAwareFlightData,
        date: String,
        allFlights: [FlightAwareFlightData]
    ) -> Bool {
        guard flight.scheduledOut?.hasPrefix(date) == true else { return false }

        guard let inbound = flight.inboundFaFlightId else {
            return !hasArrivalAtOrigin(for: flight, in: allFlights)
        }

        return !inbound.hasPrefix(flight.ident)
    }

    private func hasArrivalAtOrigin(
        for flight: FlightAwareFlightData,
        in allFlights: [FlightAwareFlightData]
    ) -> Bool {
        allFlights.contains { other in
            other.faFlightId != flight.faFlightId &&
            other.destination.codeIata == flight.origin.codeIata &&
            (other.scheduledIn ?? "") < (flight.scheduledOut ?? "")
        }
    }

    private func buildChain(
        from start: FlightAwareFlightData,
        allFlights: [FlightAwareFlightData]
    ) -> FlightRouteGroup {
        var chain = [start]
        var current = start

        while let next = findNextByInbound(current: current, in: allFlights) {
            chain.append(next)
            current = next
        }

        if chain.count == 1 {
            if let next = findNextByGeography(current: current, in: allFlights) {
                chain.append(next)
                current = next

                while let following = findNextByInbound(current: current, in: allFlights) {
                    chain.append(following)
                    current = following
                }
            }
        }

        return FlightRouteGroup(segments: chain)
    }

    private func findNextByInbound(
        current: FlightAwareFlightData,
        in allFlights: [FlightAwareFlightData]
    ) -> FlightAwareFlightData? {
        allFlights.first { $0.inboundFaFlightId == current.faFlightId }
    }

    private func findNextByGeography(
        current: FlightAwareFlightData,
        in allFlights: [FlightAwareFlightData]
    ) -> FlightAwareFlightData? {
        allFlights.first { other in
            other.faFlightId != current.faFlightId &&
            other.origin.codeIata == current.destination.codeIata &&
            (other.scheduledOut ?? "") > (current.scheduledIn ?? "")
        }
    }
}
