//
//  Extensions.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 05/02/22.
//

import Foundation
import SwiftUI

extension View {
    func deletePersonalPlan(userid: String?, token: String?, planName: String,coach: Bool) {
        guard let userid = userid else {
            return
        }
        guard let token = token else {
            return
        }
        
        ApiManager().deletePlan(userid: userid, token: token, planName: planName, coach: coach) { result in
            switch (result) {
            case .success(let response):
                print(response.message ?? "")
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
    }
}
