//
//  FlightSearchPresenter.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

import Foundation

protocol FlightSearchPresenter: Sendable {
    func searchFlights() async
}

@Observable
@MainActor
final class FlightSearchPresenterImpl: FlightSearchPresenter {
    
    let interactor: APIService
    
    init(interactor: APIService) {
        self.interactor = interactor
    }
    
    func searchFlights() async {
        
        do {
            let amadeusToken: FlightResponse = try await interactor.fetch(endpoint: .flightStatus(flightNumber: "BA249", date: "2026-01-15"))
            print(amadeusToken)
        } catch {
            print(error)
        }
    }
}
