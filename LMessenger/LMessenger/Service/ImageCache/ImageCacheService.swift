//
//  ImageCacheService.swift
//  LMessenger
//
//  Created by 변상필 on 12/21/23.
//

import UIKit
import Combine

protocol ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never>
}

class ImageCacheService: ImageCacheServiceType {
    
    let memoryStorage: MemoryStorageType
    let diskStorage: DiskStorageType
    
    init(memoryStorage: MemoryStorageType, diskStorage: DiskStorageType) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
    }
    
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        /*
         1. memory storage 확인
         2. disk storage 확인
         3. url session 이미지 다운로드
         4. memory, disk storage에 각각 저장
         
         => combine으로 작업
         */
        imageWithMemoryCache(for: key)
        // 만약에 이미지가 있으면
            .flatMap { image -> AnyPublisher<UIImage?, Never> in
                if let image {
                    return Just(image).eraseToAnyPublisher()
                } else {
                    // memory storage에 이미지가 없다면 disk storage 확인
                    return self.imageWithDiskCache(for: key)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // 1. memory storage 확인 함수
    func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            let image = self?.memoryStorage.value(for: key)
            promise(.success(image))
        }.eraseToAnyPublisher()
    }
    
    // 2. disk storage 확인 함수
    func imageWithDiskCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future<UIImage?, Never> { [weak self] promise in
            do {
                let image = try self?.diskStorage.value(for: key)
                promise(.success(image))
            } catch {
                promise(.success(nil))
            }
        }
        // 만약 disk에 있으면
        .flatMap { image -> AnyPublisher<UIImage?, Never> in
            if let image {
                return Just(image)
                // 이 경우일 때 메모리 캐시에는 없으나 디스크 캐시에만 있는 경우이므로
                // 메모리 캐시에 추가하는 작업 진행
                    .handleEvents(receiveOutput: { [weak self] image in
                        guard let image else { return }
                        self?.store(for: key, image: image, toDisk: false)
                    })
                    .eraseToAnyPublisher()
            } else {
                // 없으면 네트워크 통신
                return self.remoteImage(for: key)
            }
        }
        .eraseToAnyPublisher()
    }
    
    // 3. url session 이미지 다운로드 함수
    func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .map { data, _ in
                UIImage(data: data)
            }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image else { return }
                self?.store(for: urlString, image: image, toDisk: true)
            })
            .eraseToAnyPublisher()
    }
    
    
    // 저장
    /*
     캐시에 없다면 url을 통해 다운로드 후 저장
     디스크 캐시에만 있다면 메모리 캐시에 저장
     */
    func store(for key: String, image: UIImage, toDisk: Bool) {
        memoryStorage.store(for: key, image: image)
        
        if toDisk {
            try? diskStorage.store(for: key, image: image)
        }
    }
}

class StubImageCacheService: ImageCacheServiceType {
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        Empty().eraseToAnyPublisher()
    }
}
