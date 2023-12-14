//
//  UserService.swift
//  LMessenger
//
//  Created by 변상필 on 12/13/23.
//

import Foundation
import Combine

protocol UserServiceType {
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
}

class UserService: UserServiceType {
    
    private var dbRepository: UserDBRepositoryType
    
    init(dbRepository: UserDBRepositoryType) {
        self.dbRepository = dbRepository
    } 
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        // user 타입을 userObject 타입으로 바꿔 넣어야함
        dbRepository.addUser(user.toObject())
            .map { user}
            .mapError { .error($0)}
            .eraseToAnyPublisher()
    }
    
    
}

class StubUserService: UserServiceType {
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
