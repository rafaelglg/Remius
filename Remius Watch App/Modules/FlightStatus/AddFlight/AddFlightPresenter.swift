//
//  AddFlightPresenter.swift
//  Remius
//
//  Created by rafael.loggiodice on 30/3/26.
//

import Foundation

@MainActor
protocol AddFlightPresenter {
    var flightNumber: String { get set }
    var date: Date { get set }
    var isValid: Bool { get }
    var dateRange: ClosedRange<Date> { get }
    var trackedFlight: TrackedFlight { get }
}

@Observable
@MainActor
final class AddFlightPresenterImpl: AddFlightPresenter {
    var flightNumber = ""
    var date = Date()

    var isValid: Bool {
        let cleaned = flightNumber.replacingOccurrences(of: " ", with: "")
        return cleaned.count >= 4 && cleaned.contains(where: \.isNumber)
    }

    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: .now)
        let startOfYear = calendar.date(from: DateComponents(year: currentYear))!
        let endOfNextYear = calendar.date(from: DateComponents(year: currentYear + 1, month: 12, day: 31))!
        return startOfYear...endOfNextYear
    }

    var trackedFlight: TrackedFlight {
        let cleanedNumber = flightNumber
            .replacingOccurrences(of: " ", with: "")
            .uppercased()
        let formattedDate = date.formatted(.iso8601.year().month().day().dateSeparator(.dash))
        return TrackedFlight(number: cleanedNumber, date: formattedDate)
    }
}
