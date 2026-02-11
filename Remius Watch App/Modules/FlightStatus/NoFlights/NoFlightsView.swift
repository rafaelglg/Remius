//
//  NoFlightsView.swift
//  Remius
//
//  Created by Rafael Loggiodice on 7/2/26.
//

import SwiftUI

struct NoFlightsView: View {
    @State private var hasEnteredScene = false

    var body: some View {
        VStack(spacing: .xxSmall) {
            airplane
            headerSection
        }
        .scenePadding()
        .padding(.bottom, .xxSmall)
        .task(startAnimation)
    }

    var airplane: some View {
        ZStack {
            Circle()
                .fill(.blue.opacity(0.2).gradient)
                .frame(size: 90)

            Image(systemName: "airplane.up.forward")
                .resizable()
                .scaledToFit()
                .frame(size: 44)
                .foregroundStyle(.blue.gradient)
                .rotationEffect(.degrees(hasEnteredScene ? .zero : 45))
                .scaleEffect(hasEnteredScene ? 1 : 0.4)
                .offset(
                    x: hasEnteredScene ? .zero : -80,
                    y: hasEnteredScene ? .zero : 50
                )
                .opacity(hasEnteredScene ? 1 : .zero)
        }
    }

    var headerSection: some View {
        Text("noFlights.header.add")
            .font(.subheadline)
    }

    func startAnimation() async {
        try? await Task.sleep(for: .seconds(0.7))

        withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
            hasEnteredScene = true
        }
    }
}

#Preview("Airplane animation") {
    ScrollView {
        NoFlightsView()
    }
}
