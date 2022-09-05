//
//  RegisterViewModel.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 03/02/22.
//

import SwiftUI

class RegisterViewModel: ObservableObject {

    @Published var logged: Bool = false
    @Published var showError: Bool = false
    @Published var message: String = ""
    
    func registerUser(name: String,email: String,password: String,coach: Bool) {
        
        switch (coach) {
        case true:
            ApiManager().registerCoach(name: name, email: email, password: password) { result in
                switch result {
                case .success(let registerResponse):
                    DispatchQueue.main.async {
                        self.logged = true
                        UserDefaults.standard.set(registerResponse.userID, forKey: "userid")
                        UserDefaults.standard.set(registerResponse.token, forKey: "token")
                        UserDefaults.standard.set(name, forKey: "username")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(true, forKey: "coach")
                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showError = true
                        self.message = error.localizedDescription
                    }
                    
                }
            }
            
        case false:
            ApiManager().register(name: name, email: email, password: password) { result in
                switch result {
                case .success(let registerResponse):
                    DispatchQueue.main.async {
                        self.logged = true
                        UserDefaults.standard.set(registerResponse.userID, forKey: "userid")
                        UserDefaults.standard.set(registerResponse.token, forKey: "token")
                        UserDefaults.standard.set(name, forKey: "username")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(false, forKey: "coach")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showError = true
                        self.message = error.localizedDescription
                    }
                    
                }
            }
        }
    }
    
}

