//
//  FlightStatusMapperProtocol.swift
//  Remius
//
//  Created by Rafael Loggiodice on 19/2/26.
//

protocol FlightStatusMapperProtocol {
    func map(_ domainData: FlightStatusDomainData) -> [FlightStatusViewData]
}

struct FlightStatusMapper: FlightStatusMapperProtocol {
    private let flightAwareMapper: FlightAwareMapperProtocol
    private let amadeusMapper: AmadeusMapperProtocol

    init(
        flightAwareMapper: FlightAwareMapperProtocol = FlightAwareMapper(),
        amadeusMapper: AmadeusMapperProtocol = AmadeusMapper()
    ) {
        self.flightAwareMapper = flightAwareMapper
        self.amadeusMapper = amadeusMapper
    }

    func map(_ domainData: FlightStatusDomainData) -> [FlightStatusViewData] {
        switch domainData {
        case .flightAware(let groups):
            return groups.map { flightAwareMapper.map($0) }
        case .amadeus(let flights):
            return flights.map { amadeusMapper.map($0) }
        }
    }
}
