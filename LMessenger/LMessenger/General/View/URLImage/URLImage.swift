//
//  URLImage.swift
//  LMessenger
//
//  Created by 변상필 on 12/22/23.
//

import Foundation

import SwiftUI

struct URLImageView: View {
    @EnvironmentObject var container: DIContainer
    let urlString: String?
    let placeholderName: String
    
    init(urlString: String?, placeholderName: String? = nil) {
        self.urlString = urlString
        self.placeholderName = placeholderName ?? "placeholder"
    }
    
    var body: some View {
        if let urlString, !urlString.isEmpty {
            URLInnerImageView(viewModel: .init(container: container, urlString: urlString), placeholderName: placeholderName)
                .id(urlString) // innerView가 URL이 변경되었을 시 내부에 있는 StateObject도 변경해주기 위해 id를 명시적으로 지정
        } else {
            Image(placeholderName)
                .resizable()
        }
    }
}

fileprivate struct URLInnerImageView: View {
    @StateObject var viewModel: URLImageViewModel
    let placeholderName: String
    
    var placeholderImage: UIImage {
        UIImage(named: placeholderName) ?? UIImage()
    }
    
    var body: some View {
        Image(uiImage: viewModel.loadedImage ?? placeholderImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onAppear {
                if !viewModel.loadingOrSuccess {
                    viewModel.start()
                }
            }
    }
}

#Preview{
    URLImageView(urlString: nil)
}
 
