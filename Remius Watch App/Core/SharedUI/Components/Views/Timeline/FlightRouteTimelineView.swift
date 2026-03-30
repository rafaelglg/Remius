//
//  FlightRouteTimelineView.swift
//  Remius
//
//  Created by Rafael Loggiodice on 6/2/26.
//

import SwiftUI

// MARK: - Timeline View

struct FlightRouteTimelineView: View {
    let route: RouteInfo

    private enum Style {
        static let circleSize: CGFloat = 8
        static let lineWidth: CGFloat = 2
        /// Centers the line horizontally under the circles
        static var lineLeading: CGFloat { (circleSize - lineWidth) / 2 }
        /// Indents details to align with circle-row text
        static var detailsLeading: CGFloat { circleSize + .xSmall }
        /// Trims the line so it doesn't extend past the circles
        static let lineTrim: CGFloat = .xSmall
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            departureRow
            departureDetails
            Spacer().frame(height: .medium)
            arrivalDetails
            arrivalRow
        }
        .background(alignment: .leading) {
            Rectangle()
                .fill(.timelineLine)
                .frame(width: Style.lineWidth)
                .padding(.leading, Style.lineLeading)
                .padding(.vertical, Style.lineTrim)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, .xxSmall)
    }

    // MARK: - Departure

    private var departureRow: some View {
        HStack(alignment: .center, spacing: .xSmall) {
            Circle()
                .fill(.green)
                .frame(width: Style.circleSize, height: Style.circleSize)

            Text(route.departureTime)
                .font(.title3)
                .fontWeight(.bold)
                .monospacedDigit()
        }
    }

    private var departureDetails: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            if let originCity = route.originCity {
                Text(originCity)
                    .font(.caption)
                    .fontWeight(.medium)
            }

            Text(route.originCode)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.leading, Style.detailsLeading)
    }

    // MARK: - Arrival

    private var arrivalDetails: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            Text(route.arrivalTime)
                .font(.title3)
                .fontWeight(.bold)
                .monospacedDigit()

            if let destinationCity = route.destinationCity {
                Text(destinationCity)
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .padding(.leading, Style.detailsLeading)
    }

    private var arrivalRow: some View {
        HStack(alignment: .center, spacing: .xSmall) {
            Circle()
                .fill(.blue)
                .frame(width: Style.circleSize, height: Style.circleSize)

            Text(route.destinationCode)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview("Flight Route Timeline") {
    FlightRouteTimelineView(
        route: RouteInfo(
            departureTime: "14:30",
            arrivalTime: "18:45",
            originCity: "Madrid",
            originCode: "MAD",
            destinationCity: "Bristol",
            destinationCode: "BRS"
        )
    )
    .padding()
}

// MARK: - Timeline Appearance

private extension ShapeStyle where Self == Color {
    static var timelineLine: Color { .secondary.opacity(0.3) }
}
