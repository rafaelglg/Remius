//
//  ErrorViewModel.swift
//  Remius
//
//  Created by Rafael Loggiodice on 8/2/26.
//

import Foundation
import SwiftUI

struct UIError: Error {
    let title: String
}

struct FlightErrorMapper {
    static func map(error: Error) -> UIError {
        if let urlError = error as? URLError {

            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                return UIError(
                    title: String(localized: "flight.error.internet.title")
                )
            case .timedOut:
                return UIError(
                    title: String(localized: "flight.error.timeout.title")
                )
            default:
                break
            }
        }

        return UIError(title: String(localized: "flight.error.generic.title"))
    }
}
