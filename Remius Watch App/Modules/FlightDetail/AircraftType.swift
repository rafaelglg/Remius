//
//  AircraftType.swift
//  Remius
//
//  Created by Rafael Loggiodice on 7/2/26.
//

import Foundation

enum AircraftType {
    case boeing(String)
    case airbus(String)
    case other(String)

    private static let boeingModels: [String: String] = [
        "733": "Boeing 737-300",
        "734": "Boeing 737-400",
        "735": "Boeing 737-500",
        "736": "Boeing 737-600",
        "737": "Boeing 737-700",
        "738": "Boeing 737-800",
        "739": "Boeing 737-900",
        "73J": "Boeing 737-900ER",
        "7M8": "Boeing 737 MAX 8",
        "7M9": "Boeing 737 MAX 9",
        "77W": "Boeing 777-300ER",
        "777": "Boeing 777",
        "787": "Boeing 787",
        "788": "Boeing 787-8",
        "789": "Boeing 787-9"
    ]

    private static let airbusModels: [String: String] = [
        "319": "Airbus A319",
        "320": "Airbus A320",
        "321": "Airbus A321",
        "32N": "Airbus A320neo",
        "32Q": "Airbus A321neo",
        "332": "Airbus A330-200",
        "333": "Airbus A330-300",
        "338": "Airbus A330-800neo",
        "339": "Airbus A330-900neo",
        "359": "Airbus A350-900",
        "35K": "Airbus A350-1000",
        "388": "Airbus A380-800"
    ]

    init(iataCode: String) {
        if let model = Self.boeingModels[iataCode] {
            self = .boeing(model)
        } else if let model = Self.airbusModels[iataCode] {
            self = .airbus(model)
        } else {
            self = .other(iataCode)
        }
    }

    var displayName: String {
        switch self {
        case .boeing(let name), .airbus(let name):
            return name
        case .other(let code):
            return code
        }
    }

    var shortName: String {
        switch self {
        case .boeing(let name), .airbus(let name):
            // "Boeing 737-800" -> "737-800"
            return name.components(separatedBy: " ").last ?? name
        case .other(let code):
            return code
        }
    }
}
