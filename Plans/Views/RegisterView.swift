//
//  RegisterView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 03/02/22.
//

import SwiftUI

struct RegisterView: View {
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var coach: Bool = false
    @StateObject var registerVM = RegisterViewModel()
    
    var body: some View {
            VStack(spacing:15) {
                
                TextField("Username", text: self.$name)
                    .textContentType(.name)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
                TextField("Email", text: self.$email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
                SecureField("Password", text: self.$password)
                    .textContentType(.newPassword)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
                
                Toggle("Coach Account", isOn: self.$coach)
                
                Button {
                    self.registerVM.registerUser(name: self.name, email: self.email, password: self.password, coach: self.coach)
                    self.name = ""
                    self.email = ""
                    self.password = ""
                    
                } label: {
                    Text("Sign Up")
                }
                .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(20)

                Spacer()
                
            }
            .padding()
            .navigationTitle("Sign Up")
        .fullScreenCover(isPresented: self.$registerVM.logged) {
            MainTabbedView()
        }
        .alert(self.registerVM.message.replacingOccurrences(of: "\"", with: ""), isPresented: self.$registerVM.showError) {
            Button("OK", role: .cancel) { }
        }
    }
}


