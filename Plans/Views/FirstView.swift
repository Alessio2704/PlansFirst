//
//  FirstView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 03/02/22.
//

import SwiftUI

struct FirstView: View {
    
    @AppStorage("token") var token: String?
    
    var body: some View {
        
        if(self.token != nil) {
            MainTabbedView()
        } else {
            LoginView()
        }
    }
}
