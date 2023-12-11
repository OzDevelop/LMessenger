//
//  LoginButtonStyle.swift
//  LMessenger
//
//  Created by 변상필 on 12/11/23.
//

import SwiftUI

struct LoginButtonStyle: ButtonStyle {
    
    let textColor: Color
    let borderColor: Color
    
    init(textColor: Color, borderColor: Color? = nil) {
        self.textColor = textColor
        self.borderColor = borderColor ?? textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 0.8)
            }
            .padding(.horizontal, 15)
            .opacity(configuration.isPressed ? 0.5 : 1)
        
//        configuration.isPressed
    }
}

/*
 Button {
     isPresentedLoginView.toggle()
 } label: {
     Text("로그인")
         .font(.system(size: 14))
         .foregroundStyle(Color.lineAppColor)
         .frame(maxWidth: .infinity, maxHeight: 40)
 }
 .overlay {
     RoundedRectangle(cornerRadius: 5)
         .stroke(Color.lineAppColor, lineWidth: 0.8)
 }
 .padding(.horizontal, 15)
 */
