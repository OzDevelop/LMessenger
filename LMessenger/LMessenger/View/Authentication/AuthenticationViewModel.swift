//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    
    enum Action {
        case googleLogin
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
    }
    
    @Published var authenticationState : AuthenticationState = .unauthenticated
    @Published var isLoading = false
    
    var userId: String?
    
    private var currentNonce: String?
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .googleLogin:
            isLoading = true
            container.services.authService.signInWithGoogle()
            // TODO: - db 추가 작업
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.isLoading = false
                        
                    }
                } receiveValue: { [weak self] user in
                    self?.isLoading = false
                    self?.userId = user.id
                }.store(in: &subscriptions)

        case let .appleLogin(request):
            let nonce = container.services.authService.handleSignInWithAppleRequest(request)
            currentNonce = nonce
            
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                
                container.services.authService.handleSignInWithAppleCompletion(authorization, none: nonce)
                    .sink { completion in
                        if case .failure = completion {
                            self.isLoading = false
                            
                        }
                    } receiveValue: { [weak self] user in
                        self?.isLoading = false
                        self?.userId = user.id
                    }.store(in: &subscriptions)
            } else if case let .failure(error) = result {
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
}
