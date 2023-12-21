//
//  Services.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import Foundation

protocol ServiceType {
    var authService: AuthenticationServiceType { get set }
    var userService: UserServiceType { get set }
    var contactService: ContactServiceType { get set }
    var photoPickerService: PhotoPickerServiceType { get set }
    var imageCacheService: ImageCacheServiceType { get set }
}

class Services: ServiceType {
    var userService: UserServiceType
    var authService: AuthenticationServiceType
    var contactService: ContactServiceType
    var photoPickerService: PhotoPickerServiceType
    var imageCacheService: ImageCacheServiceType

    init() {
        self.authService = AuthenticationService()
        self.userService = UserService(dbRepository: UserDBRepository())
        self.contactService = ContactService()
        self.photoPickerService = PhotoPickerService()
        self.imageCacheService = ImageCacheService(memoryStorage: MemoryStorage(), diskStorage: DiskStorage())
    }
}

class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
    var contactService: ContactServiceType = ContactService()
    var photoPickerService: PhotoPickerServiceType = PhotoPickerService()
    var imageCacheService: ImageCacheServiceType = StubImageCacheService()
}
