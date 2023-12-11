//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import Foundation

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    
    @Published var authenticationState : AuthenticationState = .unauthenticated
    
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
        
        
    }
}
