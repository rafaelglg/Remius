//
//  AmadeusRepository.swift
//  Remius
//
//  Created by Rafael Loggiodice on 19/2/26.
//

protocol AmadeusRepository: Sendable {
    func fetchFlights(for flightNumber: String, date: String) async throws -> [DatedFlight]
}
