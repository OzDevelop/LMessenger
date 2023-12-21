//
//  MyProfileDescEditView.swift
//  LMessenger
//
//  Created by 변상필 on 12/19/23.
//

import SwiftUI

struct MyProfileDescEditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var description: String
    
    //프로필 뷰에서 완료 버튼이 눌렸을때만 어떤 작업을 할 수 있또록 하기 위해 클로저 만듬
    var onCompleted: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("상태메시지를 입력해주세요", text: $description)
                    .multilineTextAlignment(.center) //textField의 정렬을 center로 하기 위해서
            }
            .toolbar {
                Button("완료") {
                    dismiss()
                    onCompleted(description)
                }
                .disabled(description.isEmpty)
            }
        }
    }
}

#Preview {
    MyProfileDescEditView(description: "") { _ in
        
    }
}
