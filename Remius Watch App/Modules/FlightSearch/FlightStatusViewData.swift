//
//  FlightStatusViewData.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/1/26.
//


struct FlightStatusViewData: Identifiable {
    let id = UUID()
    let flightNumber: String
    let statusText: String
    let statusColorName: String // Para que la View no gestione lógica de colores
}

// Mocks para tus vistas
extension FlightStatusViewData {
    static let mocks: [FlightStatusViewData] = [
        FlightStatusViewData(flightNumber: "IB 6252", statusText: "On Time", statusColorName: "green"),
        FlightStatusViewData(flightNumber: "AA 1234", statusText: "Delayed", statusColorName: "red")
    ]
}