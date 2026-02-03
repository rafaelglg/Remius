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

    func searchFlights() async
    func onAddFlightAction()
}

@Observable
@MainActor
final class FlightStatusPresenterMock: FlightStatusPresenter {
    var loadState: LoadState<[FlightStatusViewData]>
    var delay: Double = 0.0
    var shouldCallSearch: Bool
    var presentAddFlightSheet: Bool = false

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
        try? await Task.sleep(for: .seconds(delay))

        loadState = .success(FlightStatusViewData.mocks)
    }

    func onAddFlightAction() {
        presentAddFlightSheet.toggle()
    }
}

@Observable
@MainActor
final class FlightStatusPresenterImpl: FlightStatusPresenter {
    let interactor: FlightStatusInteractor
    let router: FlightStatusRouter

    private(set) var loadState: LoadState<[FlightStatusViewData]> = .initial
    var presentAddFlightSheet: Bool = false

    init(interactor: FlightStatusInteractor,
         router: FlightStatusRouter) {
        self.interactor = interactor
        self.router = router
    }

    func searchFlights() async {
        do {
            let flightStatus: [DatedFlight] = try await interactor.fetchFlightStatus(for: "BA249", date: "2026-04-15")

            let viewDataList = flightStatus.map { $0.toViewData() }
            loadState = .success(viewDataList)
            print(viewDataList)
        } catch {
            loadState = .failure(error)
            print(error)
        }
    }

    func didSelectFlight(_ flight: DatedFlight) {
        router.navigateToFlightDetails(flight: flight)
    }

    func onAddFlightAction() {
        presentAddFlightSheet.toggle()
    }
}

private extension DatedFlight {
    func toViewData() -> FlightStatusViewData {
        let isDelayed = true

        return FlightStatusViewData(
            flightNumber: "\(flightDesignator.carrierCode)\(flightDesignator.flightNumber)",
            statusText: isDelayed ? "Delayed" : "On Time",
            statusColorName: isDelayed ? "red" : "green"
        )
    }
}
