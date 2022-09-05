//
//  MainTabbedView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct MainTabbedView: View {
    
    @Environment(\.dismiss) var dismiss
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @StateObject var currentPlanManager = CurrentPlanManager()
    @StateObject private var networkManager = InternetConnectionManager()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(currentPlanManager)
                .environmentObject(networkManager)
                .tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        Image(systemName: "house")
                    }
                }
            
            PlansView()
                .environmentObject(currentPlanManager)
                .environmentObject(networkManager)
                .tabItem {
                    Label {
                        Text("Plans")
                    } icon: {
                        Image(systemName: "list.dash")
                    }
                    
                }
            
            ShopView()
                .tabItem {
                    Label {
                        Text("Shop")
                    } icon: {
                        Image(systemName: "bag")
                    }
                    
                }
            
            AccountView()
                .environmentObject(currentPlanManager)
                .environmentObject(networkManager)
                .tabItem {
                    Label {
                        Text("Account")
                    } icon: {
                        Image(systemName: "person.circle")
                        
                        
                    }
                }
                .onChange(of: self.token) { newValue in
                    if (newValue == nil) {
                        dismiss()
                    }
                }
                .onChange(of: self.userid) { newValue in
                    if (newValue == nil) {
                        dismiss()
                    }
                }
        }
    }
}
