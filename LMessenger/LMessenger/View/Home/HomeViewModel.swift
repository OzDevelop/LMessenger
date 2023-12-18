//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by 변상필 on 12/12/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    enum Action {
        case getUser
    }
    
    @Published var myUser: User?
    @Published var users: [User] = []
    
    private var userId: String
    private var container: DIContainer
    private var subscription = Set<AnyCancellable>()
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func send(action: Action) {
        switch action {
        case .getUser:
            container.services.userService.getUser(userId: userId)
                .sink { completion in
                    
                } receiveValue: { [weak self] user in
                    self?.myUser = user
                }.store(in: &subscription)

        }
    }
}

