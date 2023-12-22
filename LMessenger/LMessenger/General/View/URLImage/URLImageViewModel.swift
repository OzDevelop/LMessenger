//
//  URLImageViewModel.swift
//  LMessenger
//
//  Created by 변상필 on 12/22/23.
//

import UIKit
import Combine

class URLImageViewModel: ObservableObject {
    
    var loadingOrSuccess: Bool { // 로딩이 시작되었거나, 이미지를 가져왔을 경우 한번더 가져오는 것 방지
        return loading || loadedImage != nil
    }
    
    @Published var loadedImage: UIImage?
    
    private var loading: Bool = false
    private var urlString: String
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()

    init(container: DIContainer, urlString: String) {
        self.container = container
        self.urlString = urlString
    }
    
    func start() { // 캐시에서 이미지 가져오는 함수
        guard !urlString.isEmpty else { return }
        
        loading = true
        
        container.services.imageCacheService.image(for: urlString)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.loading = false
                self?.loadedImage = image
            }.store(in: &subscriptions)
    }
}
