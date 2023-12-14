//
//  UserObject.swift
//  LMessenger
//
//  Created by 변상필 on 12/14/23.
//

import Foundation

struct UserObject: Codable {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}
