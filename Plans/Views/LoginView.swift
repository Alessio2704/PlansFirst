//
//  LoginView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 03/02/22.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var coach: Bool = false
    @StateObject var loginVM = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing:15) {
                TextField("Email", text: self.$email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
                SecureField("Password", text: self.$password)
                    .textContentType(.password)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())

                Toggle("Coach Account", isOn: self.$coach)
                
                Text("Login")
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .onTapGesture {
                        self.loginVM.loginUser(email: self.email, password: self.password, coach: self.coach)
                        self.email = ""
                        self.password = ""
                    }
                
                HStack {
                    Text("You do not have an account?")
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Sign Up")
                    }
                }
                Spacer()
                
            }
            .padding()
            .navigationTitle("Login")
        }
        .fullScreenCover(isPresented: self.$loginVM.logged) {
            MainTabbedView()
        }
        .alert(self.loginVM.message.replacingOccurrences(of: "\"", with: ""), isPresented: self.$loginVM.showError) {
            Button("OK", role: .cancel) { }
        }
        
    }
}


