//
//  FlightDetailView.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/2/26.
//

import SwiftUI

struct FlightDetailView: View {
    let flight: FlightStatusViewData
    @Environment(SubscriptionRepositoryImpl.self) private var subscriptionRepository
    @ScaledMetric private var iconWidth: CGFloat = .sizeXSmall
    @State private var selectedPage: Page = .route

    private enum Page: Hashable {
        case route, duration, progress, legs, airport, aviation
    }

    private enum Layout {
        static let cardCornerRadius: CGFloat = 8
        static let cardBackgroundOpacity: CGFloat = 0.1
        static let statusTintOpacity: CGFloat = 0.8
    }

    var body: some View {
        TabView(selection: $selectedPage) {
            routeTab
            durationTab
            if flight.isInProgress { progressTab }
            if flight.hasAirportInfo { airportTab }
            if !flight.isDirectFlight { legsTab }
            if flight.hasAviationInfo { aviationTab }
        }
        .tabViewStyle(.verticalPage)
        .navigationTitle(flight.flightNumber)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(selectedPage == .route ? .visible : .hidden, for: .navigationBar)
    }

    // MARK: - Route Page

    private var routePage: some View {
        ScrollView {
            VStack(spacing: .small) {
                statusBadge
                FlightRouteTimelineView(route: flight.routeInfo)
            }
            .scenePadding(.horizontal)
        }
        .contentMargins(.top, .medium)
    }

    // MARK: - Duration Page

    private var durationPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .small) {
                detailRow(
                    icon: "clock",
                    label: "flight.detail.duration",
                    value: flight.duration
                )

                if flight.hasDelays {
                    sectionDivider
                    delaySection
                }
            }
            .scenePadding(.horizontal)
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    // MARK: - Progress Page

    private var progressPage: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            HStack {
                Image(systemName: "airplane")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text("flight.detail.inFlight")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(verbatim: "\(flight.progressPercent)%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .monospacedDigit()
            }

            ProgressView(value: flight.progressValue)
                .tint(.blue)
        }
        .padding(.small)
        .background(
            .blue.opacity(Layout.cardBackgroundOpacity),
            in: RoundedRectangle(cornerRadius: Layout.cardCornerRadius)
        )
        .scenePadding(.horizontal)
    }

    // MARK: - Legs Page

    private var legsPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .xSmall) {
                Text("flight.detail.flightRoute")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(flight.legs) { leg in
                    legRow(leg: leg, isLast: leg.id == flight.legs.last?.id)
                }
            }
            .scenePadding(.horizontal)
        }
    }

    // MARK: - Airport Page

    private var airportPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .small) {
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
            .scenePadding(.horizontal)
        }
    }

    private var sectionDivider: some View {
        Divider().padding(.vertical, .xxSmall)
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

    // MARK: - Leg Row

    private func legRow(leg: FlightLegViewData, isLast: Bool) -> some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            HStack(spacing: .xxSmall) {
                Text(verbatim: "\(leg.origin) → \(leg.destination)")
                    .font(.caption2)
                    .fontWeight(.medium)

                Spacer()

                Text(leg.duration)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            if let aircraft = leg.aircraftType {
                Label {
                    Text(aircraft)
                        .foregroundStyle(.tertiary)
                } icon: {
                    Image(systemName: "airplane")
                        .foregroundStyle(.secondary)
                }
                .font(.caption2)
            }

            if !isLast {
                Label {
                    Text("flight.detail.stopIn \(leg.destination)")
                } icon: {
                    Image(systemName: "clock.badge.exclamationmark")
                }
                .font(.caption2)
                .foregroundStyle(.orange)
                .padding(.top, .xxSmall)
            }
        }
        .padding(.vertical, .xxSmall)
    }

    // MARK: - Aviation Section

    @ViewBuilder
    private var aviationPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .xSmall) {
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
            .scenePadding(.horizontal)
        }
    }

    // MARK: - Detail Row

    private func detailRow(
        icon: String,
        label: LocalizedStringKey,
        value: String
    ) -> some View {
        HStack {
            Label(label, systemImage: icon)
                .foregroundStyle(.secondary)
                .labelReservedIconWidth(iconWidth)

            Spacer()

            Text(value)
                .fontWeight(.medium)
        }
        .font(.caption2)
    }
}

// MARK: - Tabs

private extension FlightDetailView {

    var routeTab: some View {
        routePage
            .tag(Page.route)
            .containerBackground(flight.status.color.opacity(0.4).gradient, for: .tabView)
    }

    var durationTab: some View {
        durationPage
            .tag(Page.duration)
            .containerBackground(.indigo.opacity(0.3).gradient, for: .tabView)
    }

    var progressTab: some View {
        progressPage
            .tag(Page.progress)
            .containerBackground(.blue.opacity(0.3).gradient, for: .tabView)
    }

    var airportTab: some View {
        airportPage
            .tag(Page.airport)
            .containerBackground(.teal.opacity(0.3).gradient, for: .tabView)
    }

    var legsTab: some View {
        legsPage
            .tag(Page.legs)
            .containerBackground(.orange.opacity(0.3).gradient, for: .tabView)
    }

    @ViewBuilder
    var aviationTab: some View {
        if subscriptionRepository.isSubscribed {
            aviationPage
                .tag(Page.aviation)
                .containerBackground(.orange.opacity(0.3).gradient, for: .tabView)
        } else {
            SubscriptionView()
                .tag(Page.aviation)
                .containerBackground(.purple.opacity(0.3).gradient, for: .tabView)
        }
    }
}

// MARK: - Previews

#Preview("On Time") {
    NavigationStack {
        FlightDetailView(flight: .mocks[0])
    }
    .environment(SubscriptionRepositoryImpl())
}

#Preview("Delayed") {
    NavigationStack {
        FlightDetailView(flight: .mocks[1])
    }
    .environment(SubscriptionRepositoryImpl())
}

#Preview("Departed") {
    NavigationStack {
        FlightDetailView(flight: .mocks[2])
    }
    .environment(SubscriptionRepositoryImpl())
}

#Preview("Cancelled") {
    NavigationStack {
        FlightDetailView(flight: .mocks[3])
    }
    .environment(SubscriptionRepositoryImpl())
}

#Preview("Pending") {
    NavigationStack {
        FlightDetailView(flight: .mocks[4])
    }
    .environment(SubscriptionRepositoryImpl())
}

#Preview("Landed + Baggage") {
    NavigationStack {
        FlightDetailView(flight: .mocks[5])
    }
    .environment(SubscriptionRepositoryImpl())
}

#Preview("with stops") {
    NavigationStack {
        FlightDetailView(flight: .mocks[6])
    }
    .environment(SubscriptionRepositoryImpl())
}
