//
//  ContactService.swift
//  LMessenger
//
//  Created by 변상필 on 12/18/23.
//

import Foundation
import Combine
import Contacts // 연락처 연동하기

enum ContactError: Error {
    case permissionDenied
}

protocol ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError>
}

class ContactService: ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Future { [weak self] promise in
            self?.fetchContacts {
                promise($0)
            }
        }
        .mapError { .error($0) }
        .eraseToAnyPublisher()

    }
    
    private func fetchContacts(completion: @escaping (Result<[User], Error>) -> Void) {
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { [weak self] granted, error in //권한을 얻기 위해 info.plist 추가가 필요
            if let error {
                completion(.failure(error))
                return
            }
            guard granted else {
                completion(.failure(ContactError.permissionDenied))
                return
            }
            
            DispatchQueue.global().async { [weak self] in // 이거 없으면 런타임때 메세지 뜸 + 보라색 에러
                self?.fetchContacts(store: store, completion: completion)
            }
        }
    }
    
    //실질적으로 유저의 연락처 정보를 가져오는 메소드
    private func fetchContacts(store: CNContactStore,completion: @escaping (Result<[User], Error>) -> Void) {
        let keyToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        
        let request = CNContactFetchRequest(keysToFetch: keyToFetch)
        
        var users: [User] = []
        
        do {
            
            try store.enumerateContacts(with: request) { contact, _ in
                let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                let user: User = .init(id: UUID().uuidString, name: name, phoneNumber: phoneNumber)
                
                users.append(user)
            }
            completion(.success(users))
        } catch {
            completion(.failure(error))
        }
    }
}

class StubContactService: ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
