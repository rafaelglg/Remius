//
//  FlightStatusViewData.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/1/26.
//

import Foundation

struct FlightStatusViewData: Identifiable, Hashable {
    let id = UUID()
    let flightNumber: String
    let statusText: String
    let statusColorName: String
}

extension FlightStatusViewData {
    static var mock: FlightStatusViewData {
        mocks[0]
    }

    static var mocks: [FlightStatusViewData] {
        [
            FlightStatusViewData(flightNumber: "IB 6252", statusText: "On Time", statusColorName: "green"),
            FlightStatusViewData(flightNumber: "AA 1234", statusText: "Delayed", statusColorName: "red"),
            FlightStatusViewData(flightNumber: "AA 1234", statusText: "Delayed", statusColorName: "red"),
            FlightStatusViewData(flightNumber: "AA 1234", statusText: "Delayed", statusColorName: "red"),
            FlightStatusViewData(flightNumber: "AA 1234", statusText: "Delayed", statusColorName: "red")
        ]
    }
}
