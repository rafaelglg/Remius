//
//  FlightStatusPresenterMock.swift
//  Remius
//
//  Created by Rafael Loggiodice on 31/3/26.
//

#if DEBUG

import Foundation

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

    var hasFlights: Bool {
        flightCount > .zero
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

    func loadFlights() async {
        guard shouldCallSearch else { return }

        if case .initial = loadState {
            try? await Task.sleep(for: .seconds(delay))
            loadState = .success(FlightStatusViewData.mocks)
        }
    }

    func refreshFlights() async {
        loadState = .loading
        try? await Task.sleep(for: .seconds(delay))
        loadState = .success(FlightStatusViewData.mocks)
    }

    func addFlight(_ flight: TrackedFlight) async {
        loadState = .loading
        try? await Task.sleep(for: .seconds(delay))
        loadState = .success(FlightStatusViewData.mocks)
    }

    func deleteFlight(at offsets: IndexSet) {
        guard case .success(var flights) = loadState else { return }
        for index in offsets.sorted(by: >) {
            flights.remove(at: index)
        }
        loadState = .success(flights)
    }

    func onAddFlightAction() {
        presentAddFlightSheet.toggle()
    }

    func navigateToFlightDetails(for flight: FlightStatusViewData) -> FlightDetailView {
        FlightDetailView(flight: flight)
    }

    func navigateToAddFlight(onAdd: @escaping (TrackedFlight) -> Void) -> AddFlightView {
        AddFlightAssembler().makeView(onAdd: onAdd)
    }

    func navigateTonNoFlightView() -> NoFlightsView {
        NoFlightsView()
    }
}

#endif
