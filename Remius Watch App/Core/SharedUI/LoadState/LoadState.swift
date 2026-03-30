//
//  LoadState.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

import Foundation

enum LoadState<T: Equatable>: Equatable {
    case initial
    case loading
    case success(T)
    case failure(Error)

    static func == (lhs: LoadState, rhs: LoadState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.loading, .loading):
            return true
        case let (.success(lhsModels), .success(rhsModels)):
            return lhsModels == rhsModels
        case let (.failure(lhsError), .failure(rhsError)):
            return (lhsError as NSError).domain == (rhsError as NSError).domain &&
                (lhsError as NSError).code == (rhsError as NSError).code
        default:
            return false
        }
    }
}
