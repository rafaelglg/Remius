//
//  EnvironmentConfigurable.swift
//  Remius
//
//  Created by Rafael Loggiodice on 16/2/26.
//

import Foundation

protocol EnvironmentConfigurable {
    static func value(forKey key: String) throws -> String
}

extension EnvironmentConfigurable {
    static func value(forKey key: String) throws -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String,
              !value.isEmpty else {
            throw APIError.configurationMissing(key: key)
        }
        return value
    }
}
