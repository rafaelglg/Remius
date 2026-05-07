//
//  SubscriptionProduct.swift
//  Remius
//
//  Created by Rafael Loggiodice on 7/4/26.
//

enum SubscriptionProduct: String, CaseIterable {
    case weekly = "com.remius.aviator.weekly"
    case monthly = "com.remius.aviator.monthly"
    case yearly = "com.remius.aviator.yearly"

    static let subscriptionGroupID = "E252963C"
}
