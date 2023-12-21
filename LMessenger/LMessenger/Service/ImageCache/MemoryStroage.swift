//
//  MemoryStroage.swift
//  LMessenger
//
//  Created by 변상필 on 12/21/23.
//

import UIKit

protocol MemoryStorageType {
    func value(for key: String) -> UIImage? // cache에서 값을 가져오는 함수
    func store(for key: String, image: UIImage) // cache에 저장하는 함수
}

class MemoryStorage: MemoryStorageType {
    
    var cache = NSCache<NSString, UIImage>()
    
    func value(for key: String) -> UIImage? {
        cache.object(forKey: NSString(string: key))
    }
    
    func store(for key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
