//
//  RemiusApp.swift
//  Remius Watch App
//
//  Created by rafael.loggiodice on 2/1/26.
//

import SwiftUI

@main
struct RemiusWatchApp: App {
    @State private var subscriptionRepository = SubscriptionRepositoryImpl()

    var body: some Scene {
        WindowGroup {
            FlightStatusAssemblerMock.resolve()
                .environment(subscriptionRepository)
        }
    }
}
