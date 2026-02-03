//
//  FlightStatusView.swift
//  Remius Watch App
//
//  Created by rafael.loggiodice on 2/1/26.
//

import SwiftUI

struct FlightStatusView: View {
    @State var presenter: FlightStatusPresenter
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            List {
                switch presenter.loadState {
                case .initial, .loading:
                    placeholderView
                case .success(let flights):
                    successView(flights)
                case .failure(let error):
                    errorView(error: error)
                }
            }
            .listStyle(.carousel)
            .focusable()
            .focused($isFocused)
            .navigationTitle("Flights")
            .navigationDestination(for: FlightStatusViewData.self) { flight in
                Text(flight.statusColorName)
            }
            .sheet(isPresented: $presenter.presentAddFlightSheet) {
                Text("hola")
            }
            .toolbar {
                addFlightToolbarButton
            }
        }
        .onAppear(perform: setInitialFocus)
        .task(presenter.searchFlights)
    }

    @ToolbarContentBuilder
    private var addFlightToolbarButton: some ToolbarContent {
        if case .success = presenter.loadState {
            ToolbarItem(placement: .bottomBar) {
                addFlightButton
            }
        }
    }

    private var addFlightButton: some View {
        HStack {
            Spacer()
            Button(action: presenter.onAddFlightAction) {
                Label("Add Flight", systemImage: "plus.circle.fill")
            }
        }
    }

    private var placeholderView: some View {
        ForEach(0..<12) {_ in
            FlightRowViewPlaceholder()
        }
    }

    @ViewBuilder
    private func successView(_ flights: [FlightStatusViewData]) -> some View {
        ForEach(flights) { flight in
            NavigationLink(value: flight) {
                FlightRowView(flight: flight)
            }
        }
    }

    private func errorView(error: Error) -> some View {
        VStack {
            ContentUnavailableView(
                "Could not load flight",
                systemImage: "exclamationmark.triangle.fill",
                description: Text(error.localizedDescription)
            )

            Button {
                // TBD
            } label: {
                Text("Reload")
            }
            .buttonStyle(.glassProminent)
            .controlSize(.regular)
            .tint(.blue)
            .padding([.horizontal, .bottom])
        }
        .removeListRowFormatting()
    }

    func setInitialFocus() {
        isFocused = true
    }
}

#Preview("Success State") {
    FlightStatusView(
        presenter: FlightStatusPresenterMock(delay: 2)
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
            loadState: .failure(URLError(.badURL)),
            shouldCallSearch: false
        )
    )
}
