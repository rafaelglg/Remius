//
//  FlightStatusRouter.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

protocol FlightStatusRouter {
    func navigateToFlightDetails(flight: FlightStatusViewData) -> FlightDetailView
}

struct FlightStatusRouterImpl: FlightStatusRouter {
    func navigateToFlightDetails(flight: FlightStatusViewData) -> FlightDetailView {
        FlightDetailView(flight: flight)
    }
}
