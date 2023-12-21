//
//  LoginView.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import SwiftUI
import AuthenticationServices //appleLogin

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("로그인")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.bkText)
                    .padding(.top, 80)
                Text("아래 제공되는 서비스로 로그인을 해주세요.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.greyDeep)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button {
                authViewModel.send(action: .googleLogin)
            }label: {
                Text("Google로 로그인")
            }
            .buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
            
            // appleLogin Button
            // 첫번째 클로저 - 인증 요청시 불리는 클로저
            // 컴플리션 - 인증 완료 시 호출 Result 타입 반환
            SignInWithAppleButton { request in
                authViewModel.send(action: .appleLogin(request))
                
            } onCompletion: { result in
                authViewModel.send(action: .appleLoginCompletion(result))
            }
            .frame(height: 40)
            .padding(.horizontal, 15)
            .cornerRadius(5)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("back")
                }
            }
        }
        .overlay {
            if authViewModel.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    LoginView()
}
