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

struct FlightStatusAssemblerImpl {
    static func makeFlightStatusApiService() -> APIService {
        let amadeusConfig: AmadeusConfig = AmadeusConfig()

        return APIServiceImpl(
            session: .shared,
            tokenManager: TokenManager(),
            config: amadeusConfig
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
