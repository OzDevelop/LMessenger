//
//  DIContainer.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import Foundation

class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}
