//
//  SetItemViewEdit.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 25/02/22.
//

import SwiftUI

struct SetItemViewEdit: View {

    let dimension = UIScreen.main.bounds.width - 50
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
        }
        .frame(maxWidth: dimension / 8 )
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
    }
    
}

