//
//  AddFlightAssembler.swift
//  Remius
//
//  Created by rafael.loggiodice on 31/3/26.
//

/// Builds the AddFlight module with all its dependencies.
struct AddFlightAssembler: AddFlightFactory {
    func makeView(onAdd: @escaping (TrackedFlight) -> Void) -> AddFlightView {
        let presenter = AddFlightPresenterImpl()
        return AddFlightView(presenter: presenter, onAdd: onAdd)
    }
}
