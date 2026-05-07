//
//  Log.swift
//  Remius
//
//  Created by rafael.loggiodice on 30/3/26.
//

import OSLog

enum Log {
    enum Category: String {
        case network = "Network"
        case flight = "Flight"
        case auth = "Auth"
        case persistence = "Persistence"
    }

    static func info(_ message: String, category: Category) {
        logger(for: category).info("\(message, privacy: .public)")
    }

    static func debug(_ message: String, category: Category) {
        logger(for: category).debug("\(message, privacy: .public)")
    }

    static func warning(_ message: String, category: Category) {
        logger(for: category).warning("\(message, privacy: .public)")
    }

    static func error(_ message: String, category: Category) {
        logger(for: category).error("\(message, privacy: .public)")
    }

    // MARK: - Private

    private static let subsystem = Bundle.main.bundleIdentifier ?? "rafaelloggiodice.remius.watchkitapp"

    private static func logger(for category: Category) -> Logger {
        Logger(subsystem: subsystem, category: category.rawValue)
    }
}
