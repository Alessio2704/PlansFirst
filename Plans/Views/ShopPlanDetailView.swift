//
//  ShopPlanDetailView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 09/05/22.
//

import SwiftUI

struct ShopPlanDetailView: View {
    
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @State private var downloadedPlan: PlanApi? = nil
    @State private var daysArray: [String] = []
    @Environment(\.dismiss) var dismiss
    let planToDownloadId: String
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                if let downloadedPlan = downloadedPlan {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(self.daysArray, id: \.self) { day in
                                SingleDayShopPlanPreview(downloadedPlan: downloadedPlan, day: day)
                            }
                        }
                    }
                }
                
                Spacer()
                
                if (self.downloadedPlan != nil) {
                    Button {
                        CoreDataManager.shared.downloadPlan(plan: self.downloadedPlan ?? PlanApi())
                        dismiss()
                    } label: {
                        Text("Download")
                            .frame(width: 200)
                            .padding()
                            .background(Color(uiColor: UIColor.secondarySystemFill))
                            .foregroundColor(.primary)
                            .cornerRadius(20)
                    }
                    .padding()
                }
            }
            .navigationTitle("Plan Preview")
            .onAppear {
                downloadPlan(planId: self.planToDownloadId)
                
        }
        }
        
    }
}

extension ShopPlanDetailView {
    func downloadPlan(planId: String) {
        
        guard let userid = self.userid else {
            return
        }
        guard let token = self.token else {
            return
        }
        
        guard let coach = self.coach else {
            return
        }
        
        ApiManager().getPublishedPlanData(userID: userid, token: token, coach: coach, planToDownloadId: planId) { result in
            switch (result) {
            case .success(let downloadedPlanApi):
                self.downloadedPlan = downloadedPlanApi
                
                var daysSet = Set<String>()
                
                for exercise in downloadedPlanApi.exercises {
                    daysSet.insert(exercise.day)
                }
                
                for superset in downloadedPlanApi.supersets {
                    daysSet.insert(superset.day)
                }
                
                for day in daysSet {
                    self.daysArray.append(day)
                }
                
                let weekdays = [
                    "Sun": 0,
                    "Mon": 1,
                    "Tue": 2,
                    "Wed": 3,
                    "Thu": 4,
                    "Fri": 5,
                    "Sat": 6
                ]
                
                self.daysArray.sort(by: { (weekdays[$0] ?? 7) <  (weekdays[$1] ?? 7) })
                
            case .failure(let networkingError):
                print(networkingError.localizedDescription)
            }
        }
    }
}

