//
//  SetItemView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 06/02/22.
//

import SwiftUI

struct SetItemView: View {
    let dimension = UIScreen.main.bounds.width - 50
    let widthIconDivider = 8.0
    let paddingIcon = 8.0
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
        }
        .frame(width: dimension / widthIconDivider)
        .padding(paddingIcon)
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
    }
}
