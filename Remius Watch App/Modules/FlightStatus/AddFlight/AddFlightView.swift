//
//  AddFlightView.swift
//  Remius
//
//  Created by Rafael Loggiodice on 30/3/26.
//

import SwiftUI

struct AddFlightView: View {
    @Environment(\.dismiss) private var dismiss
    @State var presenter: AddFlightPresenter

    let onAdd: (TrackedFlight) -> Void

    var body: some View {
        Form {
            flightNumberField
            datePicker
            searchButton
        }
    }

    // MARK: - Flight Number

    private var flightNumberField: some View {
        TextField("flight.add.placeholder", text: $presenter.flightNumber)
            .textInputAutocapitalization(.characters)
            .autocorrectionDisabled()
    }

    // MARK: - Date

    private var datePicker: some View {
        DatePicker(
            "flight.add.date",
            selection: $presenter.date,
            in: presenter.dateRange,
            displayedComponents: .date
        )
    }

    // MARK: - Search

    private var searchButton: some View {
        Button(action: submitFlight) {
            Text("flight.add.search")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!presenter.isValid)
        .listRowBackground(Color.clear)
    }

    private func submitFlight() {
        onAdd(presenter.trackedFlight)
        dismiss()
    }
}

#Preview {
    AddFlightView(presenter: AddFlightPresenterMock()) { flight in
        print("Flight: \(flight.number), Date: \(flight.date)")
    }
}
