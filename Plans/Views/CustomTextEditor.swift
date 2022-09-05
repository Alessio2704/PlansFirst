//
//  CustomTextEditor.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 22/02/22.
//

import SwiftUI

struct CustomTextEditor: View {
    
    let placeholder: String
    @Binding var text: String
    @Binding var isFocused: Bool
    @FocusState var focused: Bool
    let internalPadding: CGFloat = 5
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            if (self.text.isEmpty) {
                Text(self.placeholder)
                    .foregroundColor(Color.primary.opacity(0.5))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                    .padding(5)
                    
            }
            
            TextEditor(text: self.$text)
                .cornerRadius(20)
                .frame(height: 300)
                .focused($focused)

                
        }
        .onAppear {
            UITextView.appearance().backgroundColor = UIColor.secondarySystemFill
            UITextView.appearance().textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 0)
        }
        .onDisappear {
            UITextView.appearance().backgroundColor = nil
        }
        .onChange(of: self.isFocused) { newValue in
            self.focused = newValue
        }
    }
}
