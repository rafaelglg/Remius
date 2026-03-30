//
//  FlightAwareRepository.swift
//  Remius
//
//  Created by Rafael Loggiodice on 19/2/26.
//

protocol FlightAwareRepository: Sendable {
    func fetchFlights(for flightNumber: String, date: String) async throws -> [FlightRouteGroup]
}
