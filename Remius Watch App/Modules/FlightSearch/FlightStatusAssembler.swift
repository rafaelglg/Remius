//
//  FlightSearchAssembler.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

import Foundation

final class FlightSearchAssembler {
    
    static func makeFlightSearchPresenter() -> FlightSearchPresenter {
        let apiService: APIService = APIServiceImpl(
            session: .shared,
            tokenManager: TokenManager(),
            clientId: "d7N5i4zx3F7P8W7BA7bL21e1TjpiZ9c6",
            clientSecret: "8zJrgvfqZZmZUfMD"
        )
        
        return FlightSearchPresenterImpl(interactor: apiService)
    }
    
    static func resolve() -> FlightSearchView {
        FlightSearchView(presenter: makeFlightSearchPresenter())
    }
}
