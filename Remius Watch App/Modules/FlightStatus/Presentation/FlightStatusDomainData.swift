//
//  FlightStatusDomainData.swift
//  Remius
//
//  Created by Rafael Loggiodice on 19/2/26.
//

enum FlightStatusDomainData {
    case flightAware([FlightRouteGroup])
    case amadeus([DatedFlight])
}
