//
//  LMessengerApp.swift
//  LMessenger
//
//

import SwiftUI

@main
struct LMessengerApp: App {
    @StateObject var container: DIContainer = .init(services: Services())
    var body: some Scene {
        WindowGroup {
            AuthenticationView(authViewModel: .init())
                .environmentObject(container)
        }
    }
}
