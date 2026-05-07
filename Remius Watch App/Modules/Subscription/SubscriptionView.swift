//
//  SubscriptionView.swift
//  Remius
//
//  Created by Rafael Loggiodice on 7/4/26.
//

import StoreKit
import SwiftUI

struct SubscriptionView: View {
    @Environment(SubscriptionRepositoryImpl.self) private var subscriptionRepository

    var body: some View {
        SubscriptionStoreView(groupID: SubscriptionProduct.subscriptionGroupID) {
            VStack(spacing: .xSmall) {
                Image(systemName: "airplane.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.tint)

                Text("subscription.title")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text("subscription.description")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .scenePadding(.horizontal)
        }
        .storeButton(.visible, for: .restorePurchases)
        .storeButton(.hidden, for: .cancellation)
        .onInAppPurchaseCompletion { _, result in
            guard case .success(.success(let verification)) = result else { return }
            await subscriptionRepository.apply(verification)
        }
    }
}

#Preview("Default") {
    SubscriptionView()
        .environment(SubscriptionRepositoryImpl())
}
