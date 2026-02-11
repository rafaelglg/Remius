//
//  FlightStatusPresenter.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

import Foundation

protocol FlightStatusPresenter: Sendable {
    var loadState: LoadState<[FlightStatusViewData]> { get }
    var presentAddFlightSheet: Bool { get set }
    var flightCount: Int { get }

    func searchFlights() async
    func onAddFlightAction()
    func navigateToFlightDetails(for flight: FlightStatusViewData) -> FlightDetailView
}

@Observable
@MainActor
final class FlightStatusPresenterMock: FlightStatusPresenter {
    var loadState: LoadState<[FlightStatusViewData]>
    var delay: Double = 0.0
    var shouldCallSearch: Bool
    var presentAddFlightSheet: Bool = false

    var flightCount: Int {
        switch loadState {
        case .success(let flights):
            return flights.count
        case .initial, .loading, .failure:
            return .zero
        }
    }

    init(
        loadState: LoadState<[FlightStatusViewData]> = .initial,
        delay: Double = 0.0,
        shouldCallSearch: Bool = true
    ) {
        self.loadState = loadState
        self.delay = delay
        self.shouldCallSearch = shouldCallSearch
    }

    func searchFlights() async {
        guard shouldCallSearch else { return }

        if case .initial = loadState {
            try? await Task.sleep(for: .seconds(delay))
            loadState = .success(FlightStatusViewData.mocks)
        }
    }

    func onAddFlightAction() {
        presentAddFlightSheet.toggle()
    }

    func navigateToFlightDetails(for flight: FlightStatusViewData) -> FlightDetailView {
        FlightDetailView(flight: flight)
    }
}

@Observable
@MainActor
final class FlightStatusPresenterImpl: FlightStatusPresenter {
    let interactor: FlightStatusInteractor
    let router: FlightStatusRouter

    private(set) var loadState: LoadState<[FlightStatusViewData]> = .initial
    var presentAddFlightSheet: Bool = false

    var flightCount: Int {
        switch loadState {
        case .success(let flights):
            return flights.count
        case .initial, .loading, .failure:
            return .zero
        }
    }

    init(interactor: FlightStatusInteractor,
         router: FlightStatusRouter) {
        self.interactor = interactor
        self.router = router
    }

    func searchFlights() async {
        do {
            let flightStatus: [DatedFlight] = try await interactor.fetchFlightStatus(for: "AF1259", date: "2026-02-07")
            let viewDataList = flightStatus.map { $0.toViewData() }
            loadState = .success(viewDataList)
        } catch {
            let uiError = FlightErrorMapper.map(error: error)
            loadState = .failure(uiError)
        }
    }

    func navigateToFlightDetails(for flight: FlightStatusViewData) -> FlightDetailView {
        router.navigateToFlightDetails(flight: flight)
    }

    func onAddFlightAction() {
        presentAddFlightSheet.toggle()
    }
}
