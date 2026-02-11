//
//  FlightStatusInteractor.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

protocol FlightStatusInteractor: Sendable {
    func fetchFlightStatus(for flightNumber: String, date: String) async throws -> [DatedFlight]
}

struct FlightStatusInteractorMock: FlightStatusInteractor {
    func fetchFlightStatus(for _: String, date _: String) async throws -> [DatedFlight] {
        DatedFlight.mocks
    }
}

struct FlightStatusInteractorImpl: FlightStatusInteractor {
    let apiService: APIService

    func fetchFlightStatus(for flightNumber: String, date: String) async throws -> [DatedFlight] {
        let flight: FlightResponse = try await apiService.fetch(endpoint: .flightStatus(flightNumber: flightNumber, date: date))

        return flight.data
    }
}
