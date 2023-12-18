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
        case load
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
        case .load:
            container.services.userService.getUser(userId: userId)
                .handleEvents(receiveOutput: { [weak self] user in
                    self?.myUser = user
                })
                .flatMap { user in
                    self.container.services.userService.loadUsers(id: user.id)
                }
                .sink { completion in
                    
                } receiveValue: { users in
                    self.users = users
                }.store(in: &subscription)

        }
    }
}

