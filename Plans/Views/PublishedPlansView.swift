//
//  PublishedPlansView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 18/02/22.
//

import SwiftUI

struct PublishedPlansView: View {
    
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @EnvironmentObject private var networkManager: InternetConnectionManager
    @State private var publishedPlansArray = [PublishedPlanApi]()
    @State private var showDeleteAlert = false
    @State private var planNameToDelete = ""
    @State private var noData = false
    
    var body: some View {
        VStack {
            if (self.networkManager.isActive) {
                if (!self.publishedPlansArray.isEmpty) {
                    ScrollView {
                        ForEach(self.publishedPlansArray) { publishedPlan in
                            PublishedPlanCardView(plan: publishedPlan)
                                .padding()
                                .contextMenu {
                                    Button(role: .destructive) {
                                        self.planNameToDelete = publishedPlan.planName
                                        self.showDeleteAlert.toggle()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
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
        .navigationTitle(Text("Published Plans"))
        .onAppear {
            fetchPublishedPlans()
        }
        .alert("Are you sure you want to delete this plan?", isPresented: self.$showDeleteAlert) {
            Button("Delete Plan",role: .destructive, action: {
                
                guard let userid = userid else {
                    return
                }

                guard let token = token else {
                    return
                }

               
                ApiManager().deletePublishedPlan(userID: userid, token: token, planName: self.planNameToDelete) { result in
                    switch (result) {
                    case .success(let authRespone):
                        print(authRespone.message ?? "")
                        let index = self.publishedPlansArray.firstIndex(where: { $0.planName == self.planNameToDelete})
                        
                        guard let index = index else {
                            return
                        }
                        
                        self.publishedPlansArray.remove(at: index)
                        
                        if (self.publishedPlansArray.isEmpty) {
                            self.noData = true
                        }
                    case . failure(let networkingError):
                        print(networkingError.localizedDescription)
                    }
                }
            })
            
            Button("Cancel", role: .cancel, action: {
                
            })
        }
        
    }
}

extension PublishedPlansView {
    func fetchPublishedPlans() {
        guard let userid = self.userid else {
            return
        }
        guard let token = self.token else {
            return
        }
                
        ApiManager().decodePublishedPlan(userID: userid, token: token) { result in
            switch (result) {
            case .success(let planArray):
                DispatchQueue.main.async {
                    if (planArray.isEmpty) {
                        self.noData.toggle()
                    }
                    self.publishedPlansArray = planArray
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

