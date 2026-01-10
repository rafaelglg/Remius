//
//  TokenManager.swift
//  Remius
//
//  Created by rafael.loggiodice on 5/1/26.
//

actor TokenManager {
    private var currentToken: String?
    
    func setToken(_ token: String) {
        self.currentToken = token
    }
    
    func getToken() -> String? {
        currentToken
    }
    
    func clearToken() {
        currentToken = nil
    }
}
