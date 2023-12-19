//
//  MyProfileViewModel.swift
//  LMessenger
//
//  Created by 변상필 on 12/19/23.
//

import Foundation

class MyProfileViewModel: ObservableObject {
    
    @Published var userInfo: User? // 자신에 대한 user 정보
    
    private let userId: String
    private var container: DIContainer
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
}
