//
//  LMessengerApp.swift
//  LMessenger
//
//

import SwiftUI

@main
struct LMessengerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var container: DIContainer = .init(services: Services(authService: AuthenticationService()))
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView(authViewModel: .init(container: container))
                .environmentObject(container)
        }
    }
}
