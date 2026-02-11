//
//  FlightRouteTimelineView.swift
//  Remius
//
//  Created by Rafael Loggiodice on 6/2/26.
//

import SwiftUI

struct FlightRouteTimelineView: View {
    let departureTime: String
    let arrivalTime: String

    var body: some View {
        HStack(spacing: .xSmall) {
            timelineVisual
            routeTimesAndLabels
        }
        .padding(.vertical, .xxSmall)
    }

    // MARK: - Timeline Visual

    private var timelineVisual: some View {
        VStack {
            Circle()
                .fill(.green)
                .frame(size: 8)

            Rectangle()
                .fill(.secondary.opacity(0.3))
                .frame(width: 2)
                .frame(minHeight: 40, maxHeight: 80)

            Circle()
                .fill(.blue)
                .frame(size: 8)
        }
        .frame(width: 8)
    }

    // MARK: - Route Times and Labels

    private var routeTimesAndLabels: some View {
        VStack(alignment: .leading, spacing: .medium) {
            departureInfo
            arrivalInfo
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Departure Info

    private var departureInfo: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            Text(departureTime)
                .font(.title3)
                .fontWeight(.bold)
                .monospacedDigit()

            Text("flight.detail.departure")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Arrival Info

    private var arrivalInfo: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            Text(arrivalTime)
                .font(.title3)
                .fontWeight(.bold)
                .monospacedDigit()

            Text("flight.detail.arrival")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview("Flight Route Timeline") {
    FlightRouteTimelineView(
        departureTime: "14:30",
        arrivalTime: "18:45"
    )
    .padding()
}
