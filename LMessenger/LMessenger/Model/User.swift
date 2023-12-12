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
    static var stub1: User {
        .init(id: "User1_id", name: "홍길동")
    }
    static var stub2: User {
        .init(id: "User1_id", name: "홍길동")
    }
}
