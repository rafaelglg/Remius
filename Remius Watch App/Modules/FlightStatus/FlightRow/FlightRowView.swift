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
            header
            routeSection
        }
        .padding(.vertical, .xSmall)
    }

    private var header: some View {
        HStack {
            flightNumber
            Spacer()
            flightStatus
        }
    }

    private var flightNumber: some View {
        Text(flight.flightNumber)
            .font(.subheadline)
    }

    private var flightStatus: some View {
        HStack(spacing: .xxSmall) {
            Circle()
                .fill(flight.status.color)
                .frame(size: 6)

            Text(flight.statusText)
                .font(.caption2)
                .foregroundStyle(flight.status.color)
        }
    }

    private var routeSection: some View {
        Text(flight.routeCodes)
            .font(.caption2)
            .foregroundStyle(.tertiary)
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
