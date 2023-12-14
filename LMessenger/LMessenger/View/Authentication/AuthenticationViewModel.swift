//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import Foundation
import Combine

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    
    enum Action {
        case googleLogin
    }
    
    @Published var authenticationState : AuthenticationState = .unauthenticated
    
    var userId: String?
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .googleLogin:
            container.services.authService.signInWithGoogle()
            // TODO: - db 추가 작업
                .sink { completion in
                    //TODO: 실패 시
                } receiveValue: { [weak self] user in
                    self?.userId = user.id
                }.store(in: &subscriptions)

            return
        }
    }
}
