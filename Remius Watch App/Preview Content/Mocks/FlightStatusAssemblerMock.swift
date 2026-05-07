//
//  FlightStatusAssemblerMock.swift
//  Remius
//
//  Created by Rafael Loggiodice on 31/3/26.
//

#if DEBUG
final class FlightStatusAssemblerMock: FlightStatusAssembler {
    static func makeFlightSearchPresenter() -> FlightStatusPresenter {
        FlightStatusPresenterImpl(
            interactor: FlightStatusInteractorMock(),
            router: FlightStatusRouterImpl(addFlightFactory: AddFlightAssembler()),
            mapper: FlightStatusMapper()
        )
    }

    static func resolve() -> FlightStatusView {
        FlightStatusView(
            presenter: FlightStatusPresenterMock(delay: 1)
        )
    }
}
#endif
