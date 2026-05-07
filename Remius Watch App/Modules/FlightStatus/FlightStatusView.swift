//
//  FlightStatusView.swift
//  Remius Watch App
//
//  Created by rafael.loggiodice on 2/1/26.
//

import SwiftUI

struct FlightStatusView: View {
    @State var presenter: FlightStatusPresenter
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle(FlightStatusViewData.navigationTitle(count: presenter.flightCount))
                .navigationDestination(for: FlightStatusViewData.self) { flight in
                    presenter.navigateToFlightDetails(for: flight)
                }
                .sheet(isPresented: $presenter.presentAddFlightSheet) {
                    presenter.navigateToAddFlight { flight in
                        Task { await presenter.addFlight(flight) }
                    }
                }
                .toolbar {
                    addFlightToolbarButton
                    reloadFlightsToolbarButton
                }
        }
        .task(presenter.loadFlights)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task { await presenter.refreshFlights() }
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch presenter.loadState {
        case .initial, .loading:
            loadingView
        case .success(let flights):
            if flights.isEmpty {
                noFlightsView
            } else {
                flightsList(flights)
            }
        case .failure(let error):
            errorView(error: error)
        }
    }

    private var loadingView: some View {
        List {
            ForEach(0..<12, id: \.self) { _ in
                FlightRowViewPlaceholder()
            }
        }
    }

    private var noFlightsView: some View {
        presenter.navigateTonNoFlightView()
    }

    private func flightsList(_ flights: [FlightStatusViewData]) -> some View {
        List {
            ForEach(flights) { flight in
                NavigationLink(value: flight) {
                    FlightRowView(flight: flight)
                }
            }
            .onDelete(perform: presenter.deleteFlight)
        }
    }

    @ViewBuilder
    private func errorView(error: Error) -> some View {
        ScrollView {
            if let uiError = error as? UIError {
                ErrorRetryView(
                    title: uiError.title,
                    subtitle: uiError.subtitle,
                    onRetry: presenter.loadFlights)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

// MARK: Toolbar Buttons
private extension FlightStatusView {
    @ToolbarContentBuilder
    var addFlightToolbarButton: some ToolbarContent {
        if case .success = presenter.loadState {
            ToolbarItem(placement: .bottomBar) {
                addFlightButton
            }
        }
    }

    @ToolbarContentBuilder
    var reloadFlightsToolbarButton: some ToolbarContent {
        if presenter.hasFlights {
            ToolbarItem(placement: .topBarLeading) {
                reloadButton
            }
        }
    }

    var reloadButton: some View {
         Button {
             Task { await presenter.refreshFlights() }
         } label: {
             Label(FlightStatusViewData.reloadLabel, systemImage: "arrow.clockwise")
         }
     }

    var addFlightButton: some View {
        HStack {
            Spacer()
            Button(action: presenter.onAddFlightAction) {
                Label(FlightStatusViewData.addFlightLabel, systemImage: "plus.circle.fill")
            }
        }
        .shadow(radius: 5, y: 3)
    }
}

#Preview("Success State") {
    FlightStatusView(
        presenter: FlightStatusPresenterMock(delay: 1)
    )
}

#Preview("Success State 0 flights") {
    FlightStatusView(
        presenter: FlightStatusPresenterMock(
            loadState: .success([])
        )
    )
}

#Preview("Loading State") {
    FlightStatusView(
        presenter: FlightStatusPresenterMock(shouldCallSearch: false)
    )
}

#Preview("Failure State") {
    FlightStatusView(
        presenter: FlightStatusPresenterMock(
            loadState: .failure(FlightErrorMapper.map(error: URLError(.badURL))),
            shouldCallSearch: false
        )
    )
}
