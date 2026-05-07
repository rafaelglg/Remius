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
    var hasFlights: Bool { get }

    func loadFlights() async
    func refreshFlights() async
    func addFlight(_ flight: TrackedFlight) async
    func onAddFlightAction()
    func deleteFlight(at offsets: IndexSet)

    func navigateToFlightDetails(for flight: FlightStatusViewData) -> FlightDetailView
    func navigateToAddFlight(onAdd: @escaping (TrackedFlight) -> Void) -> AddFlightView
    func navigateTonNoFlightView() -> NoFlightsView
}

// MARK: - Implementation

@Observable
@MainActor
final class FlightStatusPresenterImpl: FlightStatusPresenter {
    private let interactor: FlightStatusInteractor
    private let router: FlightStatusRouter
    private let mapper: FlightStatusMapperProtocol

    /// Flights the user is tracking (input for API calls). Will be replaced by SwiftData persistence.
    private var trackedFlights: [TrackedFlight] = []

    /// Current UI state derived from API responses.
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

    var hasFlights: Bool {
        flightCount > .zero
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

    // MARK: - Public

    /// Called once on view appear. Fetches API data for all tracked flights.
    func loadFlights() async {
        guard !trackedFlights.isEmpty else {
            loadState = .success([])
            return
        }
        loadState = .loading
        await fetchAndUpdateState()
    }

    /// Re-fetches API data without showing loading state. Triggered by refresh button or scenePhase.
    func refreshFlights() async {
        guard !trackedFlights.isEmpty else { return }

        loadState = .loading
        await fetchAndUpdateState()
    }

    /// Adds a new flight to track, then fetches all flights from API.
    func addFlight(_ flight: TrackedFlight) async {
        guard !trackedFlights.contains(flight) else { return }
        trackedFlights.append(flight)
        loadState = .loading
        await fetchAndUpdateState()
    }

    /// Removes flights at given offsets from both the UI list and tracked flights.
    func deleteFlight(at offsets: IndexSet) {
        guard case .success(var flights) = loadState else { return }

        let flightNumbersToDelete = Set(offsets.map { flights[$0].flightNumber })
        flights.removeAll { flightNumbersToDelete.contains($0.flightNumber) }
        trackedFlights.removeAll { flightNumbersToDelete.contains($0.number) }
        loadState = .success(flights)
    }

    func onAddFlightAction() {
        presentAddFlightSheet.toggle()
    }
}

// MARK: - Navigation
extension FlightStatusPresenterImpl {
    func navigateToFlightDetails(for flight: FlightStatusViewData) -> FlightDetailView {
        router.navigateToFlightDetails(flight: flight)
    }

    func navigateToAddFlight(onAdd: @escaping (TrackedFlight) -> Void) -> AddFlightView {
        router.navigateToAddFlight(onAdd: onAdd)
    }

    func navigateTonNoFlightView() -> NoFlightsView {
        router.navigateTonNoFlightView()
    }
}

// MARK: - Private
private extension FlightStatusPresenterImpl {
    /// Calls API for all tracked flights and updates loadState with the result or error.
    func fetchAndUpdateState() async {
        do {
            let results = try await fetchFlightsFromAPI()
            loadState = .success(results)
        } catch {
            let uiError = FlightErrorMapper.map(error: error)
            loadState = .failure(uiError)
        }
    }

    /// Fetches flight data in parallel for each tracked flight using a TaskGroup.
    func fetchFlightsFromAPI() async throws -> [FlightStatusViewData] {
        try await withThrowingTaskGroup { group in
            for tracked in trackedFlights {
                group.addTask { [interactor, mapper] in
                    let flights = try await interactor.fetchFlightStatus(
                        for: tracked.number,
                        date: tracked.date
                    )
                    return await mapper.map(flights)
                }
            }

            var results: [FlightStatusViewData] = []
            for try await viewData in group {
                results.append(contentsOf: viewData)
            }
            return results
        }
    }
}
