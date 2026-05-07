//
//  FlightRowView 2.swift
//  Remius
//
//  Created by rafael.loggiodice on 10/1/26.
//

import SwiftUI

struct FlightRowViewPlaceholder: View {

    var body: some View {
        VStack(alignment: .leading) {
            titleSection
            bodySection
        }
    }

    var titleSection: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 60, height: 15)
            .shimmerEffect()
            .clipShape(.rect(cornerRadius: 4))
    }

    var bodySection: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 80, height: 15)
            .shimmerEffect()
            .clipShape(.rect(cornerRadius: 4))
    }
}

#Preview {
    List {
        FlightRowViewPlaceholder()
    }
}
