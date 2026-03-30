//
//  AmadeusRepositoryImpl.swift
//  Remius
//
//  Created by Rafael Loggiodice on 19/2/26.
//

struct AmadeusRepositoryImpl: AmadeusRepository {
    let apiService: APIService

    func fetchFlights(for flightNumber: String, date: String) async throws -> [DatedFlight] {
        let endpoint = AmadeusEndpoints.flightStatus(
            flightNumber: flightNumber,
            date: date
        )
        let response: FlightResponse = try await apiService.fetch(endpoint: endpoint)
        return response.data
    }
}
