//
//  ShopViewViewModel.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 21/02/22.
//

import SwiftUI

class ShopViewViewModel: ObservableObject {
    
    @Published var planInfoArray: [PublicPlanInfoApi] = [PublicPlanInfoApi]()
    @Published var noPlans = false
    @Published var loading = false

    
    func populateData(userID:String,token:String, coach:Bool, getPublishedPlanRequestApi:GetPublicPlanRequestApi, page: Int) {
        ApiManager().getPublishedPlanInfo(userID: userID, token: token, coach: coach, getPublishedPlanRequestApi: getPublishedPlanRequestApi, page: page) { result in
            switch (result) {
            case .success(let publishedPlansInfoArray):
                if (publishedPlansInfoArray.isEmpty && self.planInfoArray.isEmpty) {
                    self.noPlans = true
                    self.loading = false
                } else {
                    self.planInfoArray.append(contentsOf: publishedPlansInfoArray)
                    self.loading = false
                }
            case .failure(let networkingError):
                print(networkingError.localizedDescription)
                self.loading = false
            }
        }
    }
    
    func shouldLoadData(id:String) -> Bool {
        if (self.planInfoArray.isEmpty) {
            return false
        } else {
            return id == self.planInfoArray[self.planInfoArray.count - 1].planId
        }
    }
}
