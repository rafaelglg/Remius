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
    private let interactor: FlightStatusInteractor
    private let router: FlightStatusRouter
    private let mapper: FlightStatusMapperProtocol

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

    init(
        interactor: FlightStatusInteractor,
        router: FlightStatusRouter,
        mapper: FlightStatusMapperProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.mapper = mapper
    }

    func searchFlights() async {
        loadState = .loading

        do {
            let flights = try await interactor.fetchFlightStatus(
                for: "AF1259",
                date: "2026-02-17"
            )
            let viewData = mapper.map(flights)
            loadState = .success(viewData)
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
