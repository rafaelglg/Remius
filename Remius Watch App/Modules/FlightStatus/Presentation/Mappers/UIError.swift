//
//  UIError.swift
//  Remius
//
//  Created by Rafael Loggiodice on 8/2/26.
//

import Foundation
import SwiftUI
import OSLog

struct UIError: Error {
    let title: String
    let subtitle: String?

    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
}

struct FlightErrorMapper {
    private static let logger = Logger(subsystem: "com.remius.app", category: "FlightError")

    static func map(error: Error) -> UIError {
        // Log technical error for analytics/debugging
        logTechnicalError(error)

        // Map to user-friendly message
        if let urlError = error as? URLError {
            return mapURLError(urlError)
        }

        if let apiError = error as? APIError {
            return mapAPIError(apiError)
        }

        return UIError(
            title: String(localized: "flight.error.generic.title"),
            subtitle: String(localized: "flight.error.generic.subtitle")
        )
    }

    // MARK: - URLError

    private static func mapURLError(_ error: URLError) -> UIError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            return UIError(
                title: String(localized: "flight.error.internet.title"),
                subtitle: String(localized: "flight.error.internet.subtitle")
            )
        case .timedOut:
            return UIError(
                title: String(localized: "flight.error.timeout.title"),
                subtitle: String(localized: "flight.error.timeout.subtitle")
            )
        default:
            return UIError(
                title: String(localized: "flight.error.generic.title"),
                subtitle: String(localized: "flight.error.generic.subtitle")
            )
        }
    }

    // MARK: - APIError

    private static func mapAPIError(_ error: APIError) -> UIError {
        switch error {
        case .itemNotFound:
            return UIError(
                title: String(localized: "flight.error.notFound.title"),
                subtitle: String(localized: "flight.error.notFound.subtitle")
            )
        case .unauthorized:
            return UIError(
                title: String(localized: "flight.error.generic.title"),
                subtitle: String(localized: "flight.error.generic.subtitle")
            )
        case .invalidURL, .decodingError, .serverError, .configurationMissing:
            return UIError(
                title: String(localized: "flight.error.generic.title"),
                subtitle: String(localized: "flight.error.generic.subtitle")
            )
        case .networkError:
            return UIError(
                title: String(localized: "flight.error.internet.title"),
                subtitle: String(localized: "flight.error.internet.subtitle")
            )
        }
    }

    // MARK: - Logging

    private static func logTechnicalError(_ error: Error) {
        if let apiError = error as? APIError {
            logger.error("API Error: \(apiError.technicalDescription)")
        } else {
            logger.error("Error: \(error.localizedDescription)")
        }
    }
}
