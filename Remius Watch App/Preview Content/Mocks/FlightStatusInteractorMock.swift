//
//  FlightStatusInteractorMock.swift
//  Remius
//
//  Created by Rafael Loggiodice on 31/3/26.
//

#if DEBUG

struct FlightStatusInteractorMock: FlightStatusInteractor {
    func fetchFlightStatus(for flightNumber: String, date: String) async throws -> FlightStatusDomainData {
        .amadeus(DatedFlight.mocks)
    }
}

#endif
