//
//  UserDBRepository.swift
//  LMessenger
//
//  Created by 변상필 on 12/13/23.
//

import Foundation
import Combine
import FirebaseDatabase

protocol UserDBRepositoryType {
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    
}

//홈뷰 03강 23분
class UserDBRepository: UserDBRepositoryType {
    
    var db: DatabaseReference = Database.database().reference()
    
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        // object > data > dic
        Just(object)
            .compactMap { try? JSONEncoder().encode($0)}
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
        // dic으로 만든것까지 된 듯
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in // User/userID/..
                    self?.db.child(DBKey.Users).child(object.id).setValue(value) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
}
