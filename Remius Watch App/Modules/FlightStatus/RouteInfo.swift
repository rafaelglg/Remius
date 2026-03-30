//
//  RouteInfo.swift
//  Remius
//
//  Created by Rafael Loggiodice on 28/2/26.
//

struct RouteInfo: Hashable {
    let departureTime: String
    let arrivalTime: String
    let originCity: String?
    let originCode: String
    let destinationCity: String?
    let destinationCode: String
}
