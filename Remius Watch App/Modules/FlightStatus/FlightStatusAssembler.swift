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

struct FlightStatusAssemblerImpl: FlightStatusAssembler {
    private static let activeProvider: FlightProvider = .flightAware

    // MARK: - Provider

    private enum FlightProvider {
        case amadeus
        case flightAware
    }

    private static func makeAPIService() -> APIService {
        switch activeProvider {
        case .flightAware:
            return FlightAwareAPIService(
                session: .shared,
                config: FlightAwareConfig.production
            )
        case .amadeus:
            return AmadeusAPIService(
                session: .shared,
                tokenManager: TokenManager(),
                config: AmadeusConfig.production
            )
        }
    }

    private static func makeFlightRouteGrouper() -> FlightRouteGrouper {
        FlightRouteGrouper()
    }

    // MARK: - Interactor
    private static func makeFlightStatusInteractor() -> FlightStatusInteractor {
        switch activeProvider {
        case .flightAware:
            return FlightAwareInteractor(
                repository: FlightAwareRepositoryImpl(apiService: makeAPIService(),
                                                      grouper: makeFlightRouteGrouper())
            )
        case .amadeus:
            return AmadeusInteractor(
                repository: AmadeusRepositoryImpl(apiService: makeAPIService())
            )
        }
    }

    static func makeFlightStatusRouter() -> FlightStatusRouter {
        FlightStatusRouterImpl()
    }

    static func makeFlightSearchPresenter() -> FlightStatusPresenter {
        FlightStatusPresenterImpl(
            interactor: makeFlightStatusInteractor(),
            router: makeFlightStatusRouter(),
            mapper: FlightStatusMapper()
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
            router: FlightStatusRouterImpl(),
            mapper: FlightStatusMapper()
        )
    }

    static func resolve() -> FlightStatusView {
        FlightStatusView(
            presenter: FlightStatusPresenterMock()
        )
    }
}
