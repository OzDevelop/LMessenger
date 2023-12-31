//
//  AuthenticationView.swift
//  LMessenger
//
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainTabView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
            
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(authViewModel: .init(container: .init(services: StubService())))
    }
}
