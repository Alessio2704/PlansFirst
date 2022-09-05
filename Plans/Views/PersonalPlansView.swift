//
//  PersonalPlansView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 04/02/22.
//

import SwiftUI

struct PersonalPlansView: View {
    
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @EnvironmentObject private var networkManager: InternetConnectionManager
    @State private var plansInCloudArray = [PlanApi]()
    @State private var showDeleteAlert = false
    @State private var planNameToDelete = ""
    @State private var noData = false
    
    var body: some View {
        VStack {
            if (self.networkManager.isActive) {
                if (!self.plansInCloudArray.isEmpty) {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(self.plansInCloudArray) { planInCloud in
                                PlanCloudCardView(plan: planInCloud)
                                    .contextMenu {
                                        Button {
                                            savePlanOnDevice(plan: planInCloud)
                                        } label: {
                                            Label {
                                                Text("Save")
                                            } icon: {
                                                Image(systemName: "square.and.arrow.down")
                                            }
                                        }
                                        
                                        Button(role: .destructive) {
                                            self.planNameToDelete = planInCloud.planName
                                            self.showDeleteAlert.toggle()
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                }  else if (!self.noData) {
                    ProgressView()
                } else {
                    Text("No plans yet")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("No internet connection")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle(Text("Plans in Cloud"))
        .onAppear {
            fetchPersonalPlans()
        }
        .alert("Are you sure you want to delete this plan?", isPresented: self.$showDeleteAlert) {
            Button("Delete Plan",role: .destructive, action: {
                guard let coach = coach else {
                    return
                }

                deletePersonalPlan(userid: self.userid, token: self.token, planName: self.planNameToDelete, coach: coach)
                
                let index = self.plansInCloudArray.firstIndex(where: { $0.planName == self.planNameToDelete})
                
                guard let index = index else {
                    return
                }
                
                self.plansInCloudArray.remove(at: index)
                 
                if (self.plansInCloudArray.isEmpty) {
                    self.noData = true
                }
                
            })
            
            Button("Cancel", role: .cancel, action: {
                
            })
        }
        
    }
}

extension PersonalPlansView {
    func fetchPersonalPlans() {
        guard let userid = self.userid else {
            return
        }
        guard let token = self.token else {
            return
        }
        
        guard let coach = self.coach else {
            return
        }
                
        ApiManager().decodePlan(userID: userid, token: token, coach: coach) { result in
            switch (result) {
            case .success(let planArray):
                DispatchQueue.main.async {
                    if (planArray.isEmpty) {
                        self.noData.toggle()
                    }
                    self.plansInCloudArray = planArray
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func savePlanOnDevice(plan:PlanApi) {
        CoreDataManager().downloadPlan(plan: plan)
    }
}
