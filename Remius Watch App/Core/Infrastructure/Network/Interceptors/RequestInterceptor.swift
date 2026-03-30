//
//  RequestInterceptor.swift
//  Remius
//
//  Created by Rafael Loggiodice on 17/2/26.
//

import Foundation

/// Protocol that allows intercepting and modifying requests before they are sent.
protocol RequestInterceptor {
    func intercept(_ request: URLRequest) -> URLRequest
}
