//
//  AccountView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 03/02/22.
//

import SwiftUI

struct AccountView: View {
    
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("username") var username: String?
    @AppStorage("email") var email: String?
    @AppStorage("coach") var coach: Bool?
    @State private var showDeleteUserAlert = false
    @EnvironmentObject private var networkManager: InternetConnectionManager
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(spacing: 20) {
                        Image(systemName: "person")
                            .font(.title)
                            .padding()
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder())
                        VStack(alignment: .leading, spacing: 10) {
                            Text(self.username ?? "")
                                .font(.body)
                            Text(self.email ?? "")
                                .font(.footnote)
                        }
                        if (coach ?? false) {
                            Image(systemName: "checkmark.circle")
                                .font(.title)
                                .padding()
                                .clipShape(Circle())
                                .foregroundColor(.green)
                        }
                    }
                }
                
                if (self.networkManager.isActive) {
                    Section {
                        NavigationLink {
                            PersonalPlansView()
                        } label: {
                            Text("Plans in Cloud")
                        }
                    }
                    
                    if (self.coach ?? false == true) {
                        Section {
                            NavigationLink {
                                PublishedPlansView()
                            } label: {
                                Text("Published Plans")
                            }
                        }
                    }
                    
                    Section {
                        NavigationLink {
                            ExerciseListStatsView()
                        } label: {
                            Text("Exercises Statistics")
                        }
                    }
                    
                    Section {
                        Button {
                            self.showDeleteUserAlert.toggle()
                        } label: {
                            Text("Delete Account")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(Text("Account"))
            .toolbar(content: {
                Button {
                    UserDefaults.standard.removeObject(forKey: "token")
                } label: {
                    Text("Log Out")
                    
                }
            })
        }
        .alert("Are you sure you want to delete your account?", isPresented: self.$showDeleteUserAlert) {
            Button("Delete Account", role: .destructive ,action: {
                
                guard let userid = userid else {
                    return
                }
                
                guard let token = token else {
                    return
                }
                
                guard let coach = coach else {
                    return
                }
                
                
                ApiManager().deleteAccount(userid: userid, token: token,coach: coach) { result in
                    switch (result) {
                    case .success(_):
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.removeObject(forKey: "userid")
                        UserDefaults.standard.removeObject(forKey: "email")
                        UserDefaults.standard.removeObject(forKey: "coach")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            })
            
            Button("Cancel", role: .cancel, action: {
                
            })
        }
    }
}
