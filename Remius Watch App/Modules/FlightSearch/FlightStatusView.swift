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
                    ProgressView()
                case .success(let flights):
                    successView(flights)
                case .failure(let error):
                    errorView(error: error)
                }
            }
            .listStyle(.automatic)
            .focusable()
            .focused($isFocused)
            .navigationTitle("Flights")
            .navigationDestination(for: FlightStatusViewData.self) { flight in
                Text(flight.statusColorName)
            }
        }
        .onAppear { isFocused = true }
        .task(presenter.searchFlights)
    }

    func successView(_ flights: [FlightStatusViewData]) -> some View {
        ForEach(flights) { flight in
            NavigationLink(value: flight) {
                FlightRowView(flight: flight)
            }
        }
    }

    func errorView(error: Error) -> some View {
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
}

#Preview("Success State") {
    FlightStatusView(presenter: FlightStatusPresenterMock())
}

#Preview("Loading State") {
    FlightStatusView(presenter: FlightStatusPresenterMock(shouldCallSearch: false))
}

#Preview("Failure State") {
    FlightStatusView(
        presenter: FlightStatusPresenterMock(
            loadState: .failure(URLError(.badURL)),
            shouldCallSearch: false
        )
    )
}
