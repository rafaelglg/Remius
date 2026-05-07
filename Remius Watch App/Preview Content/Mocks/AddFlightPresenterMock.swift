//
//  AddFlightPresenterMock.swift
//  Remius
//
//  Created by Rafael Loggiodice on 31/3/26.
//

#if DEBUG

import Foundation

@Observable
@MainActor
final class AddFlightPresenterMock: AddFlightPresenter {
    var flightNumber = "AF1259"
    var date = Date()
    var isValid = true

    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: .now)
        let startOfYear = calendar.date(from: DateComponents(year: currentYear))!
        let endOfNextYear = calendar.date(from: DateComponents(year: currentYear + 1, month: 12, day: 31))!
        return startOfYear...endOfNextYear
    }

    var trackedFlight: TrackedFlight {
        TrackedFlight(number: "AF1259", date: "2026-03-30")
    }
}

#endif
