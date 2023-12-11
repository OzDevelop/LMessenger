//
//  Services.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import Foundation

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    
    init(authService: AuthenticationServiceType) {
        self.authService = AuthenticationService()
    }
}

class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
}
