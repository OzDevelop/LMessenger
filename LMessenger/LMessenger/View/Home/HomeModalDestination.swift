//
//  HomeModalDestination.swift
//  LMessenger
//
//  Created by 변상필 on 12/18/23.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(String)
    
    var id: Int {
        hashValue 
    }
}
