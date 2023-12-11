//
//  AuthenticationView.swift
//  LMessenger
//
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    var body: some View {
        switch authViewModel.authenticationState {
        case .unauthenticated:
            LoginIntroView()
        case .authenticated:
            MainTabView()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(authViewModel: .init(container: .init(services: StubService())))
    }
}
