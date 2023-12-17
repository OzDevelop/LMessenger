//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by 변상필 on 12/12/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var myUser: User?
    @Published var users: [User] = [.stub1, .stub2]
    
}

