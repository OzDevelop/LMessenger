//
//  User.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import Foundation

struct User {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}

extension User {
    func toObject() -> UserObject {
        .init(id: id,
              name: name,
              phoneNumber: phoneNumber,
              profileURL: profileURL,
              description: description
        )
    }
}

extension User {
    static var stub1: User {
        .init(id: "User1_id", name: "홍길동")
    }
    static var stub2: User {
        .init(id: "User2_id", name: "둘리")
    }
}


