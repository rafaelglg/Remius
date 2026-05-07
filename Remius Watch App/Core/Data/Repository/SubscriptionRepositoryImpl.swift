//
//  SubscriptionRepositoryImpl.swift
//  Remius
//
//  Created by Rafael Loggiodice on 7/4/26.
//

import Foundation
import StoreKit

@MainActor
@Observable
final class SubscriptionRepositoryImpl: SubscriptionRepository {
    private var activeSubscriptions: Set<String> = []

    var isSubscribed: Bool {
        !activeSubscriptions.isEmpty
    }

    init() {
        Task(priority: .background) { await self.processStartupTransactions() }
        Task(priority: .background) { await self.listenForUpdates() }
    }

    func apply(_ result: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = result,
              SubscriptionProduct(rawValue: transaction.productID) != nil else {
            return
        }

        if isActive(transaction) {
            activeSubscriptions.insert(transaction.productID)
        } else {
            activeSubscriptions.remove(transaction.productID)
        }

        await transaction.finish()
    }

    private func processStartupTransactions() async {
        for await result in Transaction.unfinished {
            await apply(result)
        }
        for await result in Transaction.currentEntitlements {
            await apply(result)
        }
    }

    private func listenForUpdates() async {
        for await result in Transaction.updates {
            await apply(result)
        }
    }

    private func isActive(_ transaction: Transaction) -> Bool {
        let notRevoked = transaction.revocationDate == nil
        let notExpired = (transaction.expirationDate ?? .distantFuture) > .now
        return notRevoked && notExpired
    }
}
