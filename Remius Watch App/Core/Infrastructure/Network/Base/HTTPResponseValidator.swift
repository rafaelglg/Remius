//
//  HTTPResponseValidator.swift
//  Remius
//
//  Created by Rafael Loggiodice on 30/3/26.
//

import Foundation

enum HTTPResponseValidator {
    static func validate(_ response: URLResponse) throws(APIError) {
        guard let status = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError.serverError(statusCode: 0)
        }
        switch status {
        case 200...299: return
        case 401: throw APIError.unauthorized
        case 404: throw APIError.itemNotFound
        default: throw APIError.serverError(statusCode: status)
        }
    }
}
