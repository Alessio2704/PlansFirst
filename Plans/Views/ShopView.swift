//
//  ShopView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 19/02/22.
//

import SwiftUI

struct ShopView: View {
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @State var showFilterView = false
    @State var workoutDays = 2.0
    @State var likes = 0.0
    @State var downloads = 0.0
    @State var levelSelected = 0
    @State var coachEmail = ""
    @StateObject private var vm = ShopViewViewModel()
    @State private var currentPage: Int = 1
    let levelsArray = ["Beginner","Intermediate","Advanced"]
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Divider()
                    HStack {
                        Text("Days \(self.workoutDays, specifier: "%.0f")")
                        Text("\(Image(systemName: "heart.circle")) \(self.likes / 1000, specifier: "%.0f") k")
                        Text("\(Image(systemName: "square.and.arrow.down")) \(self.downloads / 1000, specifier: "%.0f") k")
                        Spacer()
                        
                        Button {
                            self.vm.planInfoArray.removeAll()
                            self.vm.loading = true
                            self.currentPage = 1
                            fetchPublicPlansInfo(page: self.currentPage)
                            
                        } label: {
                            Text("Search")
                                .foregroundColor(.cyan)
                        }
                        
                    }
                    .font(.body)
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: 20)
                    .padding()
                    
                    Divider()
                }
                
                if (self.vm.loading) {
                    HStack {
                        Text("Loading plans...")
                            .padding()
                        ProgressView()
                    }
                } else {
                    if (self.vm.noPlans) {
                        Text("No \(self.levelsArray[self.levelSelected].lowercased()) plan found with \(self.likes, specifier: "%.0f") likes and \(self.downloads, specifier: "%.0f") downloads on \(self.workoutDays, specifier: "%.0f") days")
                            .foregroundColor(.secondary)
                    } else {
                        ScrollView(showsIndicators:false) {
                            ForEach(self.vm.planInfoArray) { planInfo in
                                
                                NavigationLink {
                                    ShopPlanDetailView(planToDownloadId: planInfo.planId)
                                } label: {
                                    PublishedPlanShopInfoCard(plan: planInfo)
                                        .onAppear(perform: {
                                            if (self.vm.shouldLoadData(id: planInfo.planId)) {
                                                self.currentPage += 1
                                                fetchPublicPlansInfo(page: self.currentPage)
                                            }
                                        })
                                }
                                //                                    .contextMenu {
                                //                                        Button {
                                //                                            downloadPlan(planId: planInfo.planId)
                                //                                        } label: {
                                //                                            Label {
                                //                                                Text("Download")
                                //                                            } icon: {
                                //                                                Image(systemName: "square.and.arrow.down")
                                //                                            }
                                //                                        }
                                //                                    }
                            }
                        }
                        .padding(.top)
                    }
                }
                Spacer()
            }
            .navigationTitle(Text("Shop"))
            .toolbar {
                Button {
                    self.vm.noPlans = false
                    self.vm.planInfoArray.removeAll()
                    self.currentPage = 1
                    self.showFilterView.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        .fullScreenCover(isPresented: self.$showFilterView) {
            ShopFilterView(showFilterView: self.$showFilterView, workoutDays: self.$workoutDays, likes: self.$likes, downloads: self.$downloads, levelSelected: self.$levelSelected, coachEmail: self.$coachEmail)
        }
    }
}

extension ShopView {
    
    func fetchPublicPlansInfo(page:Int) {
        
        guard let userid = self.userid else {
            return
        }
        guard let token = self.token else {
            return
        }
        
        guard let coach = self.coach else {
            return
        }
        
        let apiRequestStruct = GetPublicPlanRequestApi(likes: Int(self.likes), downloads: Int(self.downloads), workoutDays: Int(self.workoutDays), level: self.levelsArray[self.levelSelected], createdBy: self.coachEmail)
        
        self.vm.populateData(userID: userid, token: token, coach: coach, getPublishedPlanRequestApi: apiRequestStruct, page: page)
    }
}
