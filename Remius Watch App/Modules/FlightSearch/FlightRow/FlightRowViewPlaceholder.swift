//
//  FlightRowView 2.swift
//  Remius
//
//  Created by rafael.loggiodice on 10/1/26.
//


struct FlightRowView: View {
    let flight: FlightStatusViewData

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(flight.flightNumber)
                .font(.headline)

                Text(flight.statusText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        FlightRowView(flight: .mock)
    }
}
