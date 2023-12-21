//
//  sha256.swift
//  LMessenger
//
//

import Foundation
import CryptoKit

//string을 sha256 처리해주는 메소드

func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
