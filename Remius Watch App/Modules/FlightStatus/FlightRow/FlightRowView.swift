//
//  FlightRowView.swift
//  Remius
//
//  Created by rafael.loggiodice on 10/1/26.
//

import SwiftUI

struct FlightRowView: View {
    let flight: FlightStatusViewData

    var body: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            Text(flight.flightNumber)
                .font(.headline)

                Text(flight.statusText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
        }
        .padding(.vertical, .xxSmall)
    }
}

#Preview {
    List {
        FlightRowView(flight: .mock)
    }
}
