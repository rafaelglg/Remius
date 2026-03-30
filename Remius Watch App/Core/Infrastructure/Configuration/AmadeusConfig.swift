//
//  AmadeusConfig.swift
//  Remius
//
//  Created by Rafael Loggiodice on 3/2/26.
//

import Foundation

protocol APIConfigurable {
    var clientId: String { get }
    var clientSecret: String { get }
}

struct AmadeusConfig: APIConfigurable, EnvironmentConfigurable {
    let clientId: String
    let clientSecret: String

    init() throws {
        self.clientId = try Self.value(forKey: "AmadeusClientID")
        self.clientSecret = try Self.value(forKey: "AmadeusClientSecret")
    }

    init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}

// MARK: - Static Configurations

extension AmadeusConfig {
    static let production = try! AmadeusConfig() // swiftlint:disable:this force_try
}
