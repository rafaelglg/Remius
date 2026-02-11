//
//  FlightDetailView.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/2/26.
//

import SwiftUI

private extension Double {
    static let mediumHighOpacity: CGFloat = 0.8
}
// TODO: Refactor this when migrating API
struct FlightDetailView: View {
    let flight: FlightStatusViewData
    @ScaledMetric private var iconWidth: CGFloat = 24

    var body: some View {
        ScrollView {
            VStack(spacing: .medium) {
                flightHeader

                if flight.hasCodeshare {
                    codeshareInfo
                }

                statusBadge
                routeSection

                Divider()
                    .padding(.vertical, .xxSmall)

                flightDurationSection

                if !flight.isDirectFlight {
                    Divider()
                        .padding(.vertical, .xxSmall)

                    flightLegsSection
                }

                Divider()
                    .padding(.vertical, .xxSmall)

                if flight.aircraftType != nil || flight.gate != nil {
                    additionalInfoSection
                }
            }
            .padding(.xxSmall)
        }
        .navigationTitle(flight.flightNumber)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Flight Header

    private var flightHeader: some View {
        VStack(spacing: .xxSmall) {
            Text(flight.flightNumber)
                .font(.title2)
                .fontWeight(.bold)

            HStack(spacing: .xxSmall) {
                Text(flight.route)
                    .font(.headline)
                    .foregroundStyle(.secondary)

                if !flight.isDirectFlight {
                    Text(verbatim: "•")
                        .foregroundStyle(.tertiary)

                    Text(flight.stopsCount)
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .padding(.xxSmall)
                        .background(.orange.opacity(0.2), in: .capsule)
                }
            }
        }
    }

    // MARK: - Codeshare Info

    private var codeshareInfo: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            HStack(spacing: .xxSmall) {
                Image(systemName: "airplane.circle.fill")
                    .font(.caption2)
                    .foregroundStyle(.blue)

                Text("flight.detail.operatedBy")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Text(flight.operatingFlightNumber ?? "")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.small)
        .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Status Badge

    private var statusBadge: some View {
        HStack {
            Circle()
                .fill(flight.status.color)
                .frame(size: .sizeTiny)

            Text(flight.statusText)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, .small)
        .padding(.vertical, .xxSmall)
        .glassEffect(
            .regular.tint(flight.status.color.opacity(.mediumHighOpacity)).interactive(),
            in: .capsule
        )
    }

    // MARK: - Route Section

    private var routeSection: some View {
        VStack(spacing: .xSmall) {
            FlightRouteTimelineView(
                departureTime: flight.departureTime,
                arrivalTime: flight.arrivalTime
            )
            .padding(.top, .sizeTiny)

            // Date and timezone info
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(flight.departureDate)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(flight.departureTimezone)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                if flight.arrivesNextDay {
                    Text("flight.detail.nextDay")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, .xxSmall)
                        .padding(.vertical, 2)
                        .background(.orange.opacity(0.2), in: Capsule())
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(flight.arrivalDate)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(flight.arrivalTimezone)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }

    // MARK: - Flight Duration Section

    private var flightDurationSection: some View {
        detailRow(
            icon: "clock",
            label: "flight.detail.duration",
            value: flight.duration
        )
    }

    // MARK: - Flight Legs Section

    private var flightLegsSection: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Text("flight.detail.flightRoute")
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(Array(flight.legs.enumerated()), id: \.element.id) { index, leg in
                legRow(leg: leg, isLast: index == flight.legs.count - 1)
            }
        }
    }

    private func legRow(leg: FlightLegViewData, isLast: Bool) -> some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            HStack(spacing: .xxSmall) {
                Image(systemName: "airplane")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(width: iconWidth)

                Text(verbatim: "\(leg.origin) → \(leg.destination)")
                    .font(.caption)
                    .fontWeight(.medium)

                Spacer()

                Text(leg.duration)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            if let aircraft = leg.aircraftType {
                HStack(spacing: .xxSmall) {
                    Color.clear.frame(width: iconWidth)
                    Text(aircraft)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            if !isLast {
                HStack(spacing: .xxSmall) {
                    Image(systemName: "clock.badge.exclamationmark")
                        .font(.caption2)
                        .frame(width: iconWidth)
                    Text("flight.detail.stopIn \(leg.destination)")
                        .font(.caption2)
                }
                .foregroundStyle(.orange)
                .padding(.top, .xxSmall)
            }
        }
        .padding(.vertical, .xxSmall)
    }

    // MARK: - Additional Info Section

    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            if flight.isDirectFlight, let aircraftType = flight.aircraftType {
                detailRow(
                    icon: "airplane",
                    label: "flight.detail.aircraft",
                    value: aircraftType
                )
            }

            if let gate = flight.gate {
                detailRow(
                    icon: "door.left.hand.open",
                    label: "flight.detail.gate",
                    value: gate
                )
            }
        }
    }

    // MARK: - Detail Row Component

    private func detailRow(
        icon: String,
        label: LocalizedStringKey,
        value: String
    ) -> some View {
        HStack(spacing: .xxSmall) {
            Label(label, systemImage: icon)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .labelReservedIconWidth(iconWidth)

            Spacer()

            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Preview

#Preview("Direct Flight") {
    NavigationStack {
        FlightDetailView(flight: .mocks[0])
    }
}

#Preview("Flight with Stop") {
    NavigationStack {
        FlightDetailView(flight: .mocks[2])
    }
}

// MARK: - Preview

#Preview("On Time Flight") {
    NavigationStack {
        FlightDetailView(flight: .mocks[0])
    }
}

#Preview("Delayed Flight") {
    NavigationStack {
        FlightDetailView(flight: .mocks[1])
    }
}

#Preview("Boarding Flight") {
    NavigationStack {
        FlightDetailView(flight: .mocks[2])
    }
}
