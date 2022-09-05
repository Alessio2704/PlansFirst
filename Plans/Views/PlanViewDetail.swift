//
//  PlanViewDetail.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct PlanViewDetail: View {
    
    let plan:Plan
    @State private var isCurrent = false
    @EnvironmentObject var currentPlanManager: CurrentPlanManager
    @EnvironmentObject private var networkManager: InternetConnectionManager
    @State private var showDeleteAlert = false
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @State private var showUploadAlert = false
    @State private var alertMessage = ""
    @State private var showUploadButton = false
    @State private var uploaded = false
    @State private var showPublishButton = false
    @State private var published = false
    @State private var showNotes = false
    @State var newNotes = ""
    
    
    
    var body: some View {
        
        VStack {
            VStack {
                
                Toggle("Set as current", isOn: self.$isCurrent)
                    .padding()
                
                Divider()
                
                
                List {
                    if (self.networkManager.isActive) {
                        
                        if (self.coach != nil && self.coach == true) {
                            if (self.showPublishButton && !self.published) {
                                Section {
                                    Button {
                                        publishPlan(message: "Plan published succesfully")
                                    } label: {
                                        Text("Publish plan")
                                    }
                                }
                            }
                        }
                        
                        if (self.showUploadButton && !self.uploaded){
                            Section {
                                Button {
                                    uploadPlan(message: "Plan uploaded succesfully")
                                } label: {
                                    Text("Upload plan")
                                }
                            }
                        }
                    }
                    Section {
                        Button {
                            self.showDeleteAlert.toggle()
                        } label: {
                            Text("Delete plan")
                                .foregroundColor(.red)
                        }
                    }
                    
                    
                }
                
            }
        }
        .toolbar {
            Button {
                self.showNotes.toggle()
            } label: {
                Image(systemName: "note.text")
            }

        }
        .onAppear {
            self.isCurrent = self.plan.isCurrent
            checkPlanExistence()
            if (self.coach ?? false) {
                checkPublishedPlanExistence()
            }
        }
        .navigationTitle(Text(self.plan.name ?? ""))
        .onChange(of: self.isCurrent) { newValue in
            CoreDataManager().updateIsCurrentAll()
            self.currentPlanManager.isCurrentPlan.removeAll()
            if (self.isCurrent) {
                self.currentPlanManager.isCurrentPlan.append(self.plan)
            }
            CoreDataManager().updateIsCurrent(plan: self.plan, isCurrent: self.isCurrent)
        }
        .alert("Are you sure you want to delete this plan?", isPresented: self.$showDeleteAlert) {
            Button("Delete Plan",role: .destructive, action: {
                
                if (self.currentPlanManager.isCurrentPlan.contains(self.plan)) {
                    self.currentPlanManager.isCurrentPlan.removeAll()
                }
                
                CoreDataManager().deletePlan(plan: self.plan)
            })
            
            Button("Cancel", role: .cancel, action: {
                
            })
        }
        .alert(self.alertMessage, isPresented: self.$showUploadAlert) {
            Button("OK", role: .cancel, action: {
                
            })
        }
        .sheet(isPresented: self.$showNotes) {
            UpdatePlanNotesView(plan: self.plan, planNotes: self.$newNotes)
        }
    }
}


extension PlanViewDetail {
    
    func checkPlanExistence() {
        guard let userid = self.userid else { return }
        guard let token = self.token else { return }
        guard let coach = self.coach else { return }
        
        ApiManager().checkPlanExistence(userid: userid, token: token, planName: self.plan.name ?? "", coach: coach) { result in
            switch (result) {
            case .success(let response):
                if (response.message != nil && response.message == "Plan found") {
                    self.showUploadButton = false
                } else if (response.message != nil && response.message == "No plan found") {
                    self.showUploadButton = true
                }
            case .failure(let networkingError):
                print(networkingError.localizedDescription)
            }
        }
    }
    
    func checkPublishedPlanExistence() {
        guard let userid = self.userid else { return }
        guard let token = self.token else { return }
        
        ApiManager().checkPublishedPlanExistence(userid: userid, token: token, planName: self.plan.name ?? "") { result in
            switch (result) {
            case .success(let response):
                if (response.message != nil && response.message == "Plan found") {
                    self.showPublishButton = false
                } else if (response.message != nil && response.message == "No plan found") {
                    self.showPublishButton = true
                }
            case .failure(let networkingError):
                print(networkingError.localizedDescription)
            }
        }
    }
    
    func uploadPlan(message: String) {
        guard let userid = self.userid else { return }
        guard let token = self.token else { return }
        guard let coach = self.coach else { return }
        
        PlanApiManager().encodeAndUploadPlan(plan: self.plan, userID: userid, token: token, coach: coach) { result in
            switch (result) {
            case .success:
                self.alertMessage = message
                self.showUploadAlert.toggle()
                self.uploaded = true
            case .failure:
                self.alertMessage = "The plan could not be uploaded. Please try later"
                self.showUploadAlert.toggle()
            }
        }
    }
    
    func publishPlan(message: String) {
        guard let userid = self.userid else { return }
        guard let token = self.token else { return }
        guard let coach = self.coach else { return }
        
        PlanApiManager().encodeAndPublishPlan(plan: self.plan, userID: userid, token: token, coach: coach) { result in
            switch (result) {
            case .success:
                self.alertMessage = message
                self.showUploadAlert.toggle()
                self.published = true
            case .failure:
                self.alertMessage = "The plan could not be uploaded. Please try later"
                self.showUploadAlert.toggle()
            }
        }
    }
}

