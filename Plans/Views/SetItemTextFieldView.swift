//
//  SetItemTextFieldView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 06/02/22.
//

import SwiftUI

struct SetItemTextFieldView: View {
    let dimension = UIScreen.main.bounds.width - 50
    let widthIconDivider = 8.0
    let paddingIcon = 9.0
    let placeholder: String
    @Binding var textValue: String
    
    var body: some View {
        VStack {
            TextField(placeholder, text: self.$textValue)
                .keyboardType(.numbersAndPunctuation)
        }
        .frame(width: dimension / widthIconDivider)
        .padding(paddingIcon)
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
    }
}
