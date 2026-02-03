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

struct AmadeusConfig: APIConfigurable {
    let clientId: String
    let clientSecret: String

    init() {
        guard let clientId = Bundle.main.infoDictionary?["AmadeusClientID"] as? String, !clientId.isEmpty else {
            fatalError("AmadeusClientId not found in Info.plist")
        }

        guard let clientSecret = Bundle.main.infoDictionary?["AmadeusClientSecret"] as? String,
              !clientSecret.isEmpty else {
            fatalError("AmadeusClientSecret not configured in Info.plist")
        }

        self.clientId = clientId
        self.clientSecret = clientSecret
    }

    init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}

// MARK: - Static Configurations

extension AmadeusConfig {
    static let production = AmadeusConfig()
}
