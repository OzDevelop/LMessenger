//
//  MyProfileViewModel.swift
//  LMessenger
//
//  Created by 변상필 on 12/19/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor // 해당 값들이 메인 액터에서 액세스됨.
class MyProfileViewModel: ObservableObject {
    
    @Published var userInfo: User? // 자신에 대한 user 정보
    @Published var isPresentedDescEditView: Bool = false
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            Task {
                await updateProfileImage(pickerItem:imageSelection)
            }
        }
    }
    
    private let userId: String
    private var container: DIContainer
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
    
    func updateDescription(_ description: String) async {
        do {
            try await container.services.userService.updateDescription(userId: userId, description: description)
            userInfo?.description = description
        } catch {
              
        }
    }
    
    func updateProfileImage(pickerItem: PhotosPickerItem?) async {
        guard let pickerItem else { return}
        do {
            let data = try await container.services.photoPickerService.loadTransdferable(from: pickerItem)
            // 이 데이터를 이용해서 스토리지에 업로드 예정
            // 이 정보를 db에 업데이트
        } catch {
            
        }
    }
}
