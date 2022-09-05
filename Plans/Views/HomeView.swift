//
//  HomeView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct HomeView: View {
    
    let filters = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    @EnvironmentObject var currentPlanManager: CurrentPlanManager
    @ObservedObject var pickerManager = showPickerManager()
    @State var pickerVar = 0
    var body: some View {
            VStack {
                FilteredList(filter: self.filters[self.pickerVar], filter2: self.currentPlanManager.isCurrentPlan.count > 0 ? self.currentPlanManager.isCurrentPlan[0].name ?? "" : "")
                    .environmentObject(self.pickerManager)
                    .environmentObject(self.currentPlanManager)
                
                Spacer()
                
                if(self.pickerManager.showPicker && !self.currentPlanManager.isCurrentPlan.isEmpty) {
                    Picker("", selection: $pickerVar) {
                        Text("Mon").tag(0)
                        Text("Tue").tag(1)
                        Text("Wed").tag(2)
                        Text("Thu").tag(3)
                        Text("Fri").tag(4)
                        Text("Sat").tag(5)
                        Text("Sun").tag(6)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                }
            }
            .onAppear {
                NotificationManager.instance.requestAuthorization()
            }

    }
}
