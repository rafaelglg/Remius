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
            HStack {
                Text(flight.flightNumber)
                    .font(.headline)

                Spacer()

                HStack(spacing: .xxSmall) {
                    Circle()
                        .fill(flight.status.color)
                        .frame(size: 6)

                    Text(flight.statusText)
                        .font(.caption2)
                        .foregroundStyle(flight.status.color)
                }
            }

            Text("\(flight.departureTime) → \(flight.arrivalTime)")
                .font(.caption2)
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, .xxSmall)
    }
}

#Preview {
    List {
        FlightRowView(flight: .mocks[0])
        FlightRowView(flight: .mocks[1])
        FlightRowView(flight: .mocks[3])
        FlightRowView(flight: .mocks[4])
    }
}
