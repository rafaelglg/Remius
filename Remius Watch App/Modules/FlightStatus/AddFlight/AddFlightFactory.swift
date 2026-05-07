//
//  AddFlightFactory.swift
//  Remius
//
//  Created by rafael.loggiodice on 31/3/26.
//

/// Abstracts creation of the AddFlight module. Injected into the Router.
protocol AddFlightFactory {
    @MainActor
    func makeView(onAdd: @escaping (TrackedFlight) -> Void) -> AddFlightView
}
