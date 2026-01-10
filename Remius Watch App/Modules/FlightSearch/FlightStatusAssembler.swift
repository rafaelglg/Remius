//
//  FlightStatusAssembler.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

import Foundation

protocol FlightStatusAssembler {
    static func resolve() -> FlightStatusView
}

enum FlightStatusAssemblerImpl {
    static func makeFlightStatusApiService() -> APIService {
        APIServiceImpl(
            session: .shared,
            tokenManager: TokenManager(),
            clientId: "d7N5i4zx3F7P8W7BA7bL21e1TjpiZ9c6",
            clientSecret: "8zJrgvfqZZmZUfMD"
        )
    }

    static func makeFlightStatusInteractor() -> FlightStatusInteractor {
        FlightStatusInteractorImpl(apiService: makeFlightStatusApiService())
    }

    static func makeFlightStatusRouter() -> FlightStatusRouter {
        FlightStatusRouterImpl()
    }

    static func makeFlightSearchPresenter() -> FlightStatusPresenter {
        FlightStatusPresenterImpl(
            interactor: makeFlightStatusInteractor(),
            router: makeFlightStatusRouter()
        )
    }

    static func resolve() -> FlightStatusView {
        FlightStatusView(presenter: makeFlightSearchPresenter())
    }
}

final class FlightStatusAssemblerMock: FlightStatusAssembler {
    static func makeFlightSearchPresenter() -> FlightStatusPresenter {
        FlightStatusPresenterImpl(
            interactor: FlightStatusInteractorMock(),
            router: FlightStatusRouterImpl()
        )
    }

    static func resolve() -> FlightStatusView {
        FlightStatusView(
            presenter: FlightStatusPresenterMock()
        )
    }
}
