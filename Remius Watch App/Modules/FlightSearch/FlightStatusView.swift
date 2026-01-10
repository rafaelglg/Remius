//
//  FlightSearchView.swift
//  Remius Watch App
//
//  Created by rafael.loggiodice on 2/1/26.
//

import SwiftUI

struct FlightSearchView: View {
    
    @State var presenter: FlightSearchPresenter
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .task(presenter.searchFlights)
        .padding()
    }
}

#Preview {
    FlightSearchView(presenter: FlightSearchAssembler.makeFlightSearchPresenter())
}
