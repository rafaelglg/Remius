//
//  SubscriptionRepository.swift
//  Remius
//
//  Created by Rafael Loggiodice on 7/4/26.
//

@MainActor
protocol SubscriptionRepository {
    var isSubscribed: Bool { get }
}
