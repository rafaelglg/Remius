//
//  FlightAwareRepositoryImpl.swift
//  Remius
//
//  Created by Rafael Loggiodice on 19/2/26.
//

// MARK: - FlightAware

struct FlightAwareRepositoryImpl: FlightAwareRepository {
    let apiService: APIService
    let grouper: FlightRouteGrouper

    func fetchFlights(for flightNumber: String, date: String) async throws -> [FlightRouteGroup] {
        let endpoint = FlightAwareEndpoints.flightStatus(
            flightNumber: flightNumber,
            date: date
        )
        let response: FlightAwareResponse = try await apiService.fetch(endpoint: endpoint)
        return grouper.group(flights: response.flights, for: date)
    }
}
