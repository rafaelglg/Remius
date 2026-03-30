//
//  FlightDetailView.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/2/26.
//

import SwiftUI

struct FlightDetailView: View {
    let flight: FlightStatusViewData
    @ScaledMetric private var iconWidth: CGFloat = 24
    @AppStorage("showAviationDetails") private var showAviationDetails = false

    private enum Layout {
        static let cardCornerRadius: CGFloat = 8
        static let cardBackgroundOpacity: CGFloat = 0.1
        static let statusTintOpacity: CGFloat = 0.8
        static let stopsBadgeOpacity: CGFloat = 0.2
    }

    var body: some View {
        ScrollView {
            VStack(spacing: .medium) {
                headerSection
                routeSection
                flightInfoSection
                additionalInfoSection
                aviationToggleSection
            }
            .padding(.xxSmall)
        }
        .navigationTitle(flight.flightNumber)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    @ViewBuilder
    private var headerSection: some View {
        flightHeader

        if flight.hasCodeshare {
            codeshareInfo
        }

        statusBadge
    }

    // MARK: - Flight Info

    @ViewBuilder
    private var flightInfoSection: some View {
        sectionDivider
        flightDurationSection

        if flight.hasDelays {
            sectionDivider
            delaySection
        }

        if flight.isInProgress {
            sectionDivider
            flightProgressSection
        }

        if !flight.isDirectFlight {
            sectionDivider
            flightLegsSection
        }

        sectionDivider
    }

    private var sectionDivider: some View {
        Divider().padding(.vertical, .xxSmall)
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

                    Text(flight.stopsCountLocalized)
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .padding(.xxSmall)
                        .background(.orange.opacity(Layout.stopsBadgeOpacity), in: .capsule)
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
        .background(.blue.opacity(Layout.cardBackgroundOpacity), in: RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
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
            .regular.tint(flight.status.color.opacity(Layout.statusTintOpacity)).interactive(),
            in: .capsule
        )
    }

    // MARK: - Route Section

    private var routeSection: some View {
        VStack(spacing: .xSmall) {
            FlightRouteTimelineView(route: flight.routeInfo)
                .padding(.top, .sizeTiny)
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

    // MARK: - Delay Section

    private var delaySection: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            Text("flight.detail.delayTitle")
                .font(.caption)
                .fontWeight(.semibold)

            if let departureDelay = flight.delayText {
                detailRow(
                    icon: "clock.badge.exclamationmark",
                    label: "flight.detail.departureDelay",
                    value: departureDelay
                )
            }

            if let arrivalDelay = flight.arrivalDelayText {
                detailRow(
                    icon: "clock.badge.exclamationmark",
                    label: "flight.detail.arrivalDelay",
                    value: arrivalDelay
                )
            }

            Text("flight.detail.delayFootnote")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .foregroundStyle(flight.isEarly ? .green : .orange)
    }

    // MARK: - Flight Progress Section

    private var flightProgressSection: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            HStack {
                Image(systemName: "airplane")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text("flight.detail.inFlight")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(flight.progressPercent)%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .monospacedDigit()
            }

            ProgressView(value: flight.progressValue)
                .tint(.blue)
        }
        .padding(.small)
        .background(.blue.opacity(Layout.cardBackgroundOpacity), in: RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
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

    // MARK: - Aviation Details (Configurable)

    @ViewBuilder
    private var aviationSection: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            if let aircraftType = flight.aircraftType {
                detailRow(
                    icon: "airplane",
                    label: "flight.detail.aircraft",
                    value: aircraftType
                )
            }

            if let speed = flight.cruisingSpeed {
                detailRow(
                    icon: "gauge.with.needle",
                    label: "flight.detail.speed",
                    value: speed
                )
            }

            if let altitude = flight.cruisingAltitude {
                detailRow(
                    icon: "arrow.up.to.line",
                    label: "flight.detail.altitude",
                    value: altitude
                )
            }
        }
    }

    // MARK: - Additional Info Section

    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            if let gateInfo = flight.gateInfo {
                detailRow(
                    icon: "door.left.hand.open",
                    label: "flight.detail.gate",
                    value: gateInfo
                )
            }

            if let baggageClaim = flight.baggageClaim {
                detailRow(
                    icon: "suitcase",
                    label: "flight.detail.baggageClaim",
                    value: String(localized: "flight.detail.carousel \(baggageClaim)")
                )
            }
        }
    }

    // MARK: - Aviation Toggle

    private var aviationToggleSection: some View {
        VStack(spacing: .small) {
            sectionDivider
            Toggle("flight.detail.aviationToggle", isOn: $showAviationDetails)
                .font(.caption2)

            if showAviationDetails {
                aviationSection
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

// MARK: - Previews

#Preview("On Time") {
    NavigationStack {
        FlightDetailView(flight: .mocks[0])
    }
}

#Preview("Delayed") {
    NavigationStack {
        FlightDetailView(flight: .mocks[1])
    }
}

#Preview("Stop + Codeshare") {
    NavigationStack {
        FlightDetailView(flight: .mocks[2])
    }
}

#Preview("In Progress") {
    NavigationStack {
        FlightDetailView(flight: .mocks[3])
    }
}

#Preview("Cancelled") {
    NavigationStack {
        FlightDetailView(flight: .mocks[4])
    }
}

#Preview("Pending") {
    NavigationStack {
        FlightDetailView(flight: .mocks[5])
    }
}

#Preview("Landed + Baggage") {
    NavigationStack {
        FlightDetailView(flight: .mocks[6])
    }
}
