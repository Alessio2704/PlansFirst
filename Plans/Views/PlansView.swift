//
//  SettingsPlanView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct PlansView: View {
    
    @State private var isShowingAddPlanView = false
    @EnvironmentObject var currentPlanManager: CurrentPlanManager
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Plan.isCurrent, ascending: false)]) var plans: FetchedResults<Plan>
    let columns: [GridItem] = [GridItem(),GridItem()]
    
    var body: some View {
        NavigationView {
            VStack {
                if(self.plans.isEmpty) {
                    VStack {
                        Text("To create a new plan tap on the \(Image(systemName: "plus")) icon")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.top, 30)
                } else {
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                ForEach(self.plans) { plan in
                                    NavigationLink {
                                        PlanViewDetail(plan: plan)
                                    } label: {
                                        PlanCard(plan: plan)

                                    }
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                Button {
                    self.isShowingAddPlanView.toggle()
                } label: {
                    Image(systemName: "plus")
                        .padding(2)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .font(.title3)
                }
            }
            .navigationTitle(Text("Plans"))
        }
        .sheet(isPresented: self.$isShowingAddPlanView) {
            AddPlanView()
        }
    }
}


