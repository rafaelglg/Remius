//
//  Int+Measurement.swift
//  Remius
//
//  Created by Rafael Loggiodice on 28/2/26.
//

import Foundation

extension Int {

    /// Converts knots to kilometers per hour.
    /// Uses Apple's `Measurement` API for accurate conversion.
    var knotsInKmh: Int {
        let measurement = Measurement(value: Double(self), unit: UnitSpeed.knots)
        return Int(measurement.converted(to: .kilometersPerHour).value)
    }

    /// Converts hundreds of feet to meters.
    /// FlightAware API returns altitude in hundreds of feet (e.g. 350 = 35,000 ft).
    var hundredsFeetInMeters: Int {
        let feet = Double(self) * 100
        let measurement = Measurement(value: feet, unit: UnitLength.feet)
        return Int(measurement.converted(to: .meters).value)
    }
}
