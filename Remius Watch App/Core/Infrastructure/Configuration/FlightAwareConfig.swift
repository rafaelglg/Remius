//
//  FlightAwareConfig.swift
//  Remius
//
//  Created by Rafael Loggiodice on 16/2/26.
//

import Foundation

struct FlightAwareConfig: EnvironmentConfigurable {
    let apiKey: String

    init() throws {
        self.apiKey = try Self.value(forKey: "FlightAwareAPIKey")
    }

    init(apiKey: String) {
        self.apiKey = apiKey
    }
}

extension FlightAwareConfig {
    static let production = try! FlightAwareConfig() // swiftlint:disable:this force_try
}
