//
//  LoginViewMOdel.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 03/02/22.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var logged: Bool = false
    @Published var showError: Bool = false
    @Published var message: String = ""
    
    func loginUser(email: String,password: String, coach:Bool) {

        ApiManager().login(email: email, password: password, coach: coach) { result in
            switch result {
            case .success(let loginResponse):
                DispatchQueue.main.async {
                    self.logged = true
                    UserDefaults.standard.set(loginResponse.userID, forKey: "userid")
                    UserDefaults.standard.set(loginResponse.token, forKey: "token")
                    UserDefaults.standard.set(loginResponse.name ?? "", forKey: "username")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(coach, forKey: "coach")
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.logged = false
                    self.showError = true
                    self.message = error.localizedDescription
                }
            }
        }
    }
}


