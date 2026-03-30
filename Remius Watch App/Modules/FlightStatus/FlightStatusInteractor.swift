//
//  FlightStatusInteractor.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

protocol FlightStatusInteractor: Sendable {
    func fetchFlightStatus(for flightNumber: String, date: String) async throws -> FlightStatusDomainData
}

// MARK: - FlightAware

struct FlightAwareInteractor: FlightStatusInteractor {
    let repository: FlightAwareRepository

    func fetchFlightStatus(for flightNumber: String, date: String) async throws -> FlightStatusDomainData {
        let groups = try await repository.fetchFlights(for: flightNumber, date: date)
        return .flightAware(groups)
    }
}

// MARK: - Amadeus

struct AmadeusInteractor: FlightStatusInteractor {
    let repository: AmadeusRepository

    func fetchFlightStatus(for flightNumber: String, date: String) async throws -> FlightStatusDomainData {
        let flights = try await repository.fetchFlights(for: flightNumber, date: date)
        return .amadeus(flights)
    }
}

// MARK: - Mock

struct FlightStatusInteractorMock: FlightStatusInteractor {
    func fetchFlightStatus(for flightNumber: String, date: String) async throws -> FlightStatusDomainData {
        .amadeus(DatedFlight.mocks)
    }
}
