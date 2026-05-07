//
//  FlightStatusRouter.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

protocol FlightStatusRouter {
    func navigateToFlightDetails(flight: FlightStatusViewData) -> FlightDetailView
    func navigateToAddFlight(onAdd: @escaping (TrackedFlight) -> Void) -> AddFlightView
    func navigateTonNoFlightView() -> NoFlightsView
}

struct FlightStatusRouterImpl: FlightStatusRouter {
    let addFlightFactory: AddFlightFactory

    func navigateToFlightDetails(flight: FlightStatusViewData) -> FlightDetailView {
        FlightDetailView(flight: flight)
    }

    func navigateToAddFlight(onAdd: @escaping (TrackedFlight) -> Void) -> AddFlightView {
        addFlightFactory.makeView(onAdd: onAdd)
    }

    func navigateTonNoFlightView() -> NoFlightsView {
        NoFlightsView()
    }
}
