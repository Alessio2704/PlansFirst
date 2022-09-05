//
//  SupersetStatView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 01/03/22.
//

import SwiftUI

struct SupersetStatView: View {
    
    let exercise: Exercise
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @State private var supersets = [Superset]()
    @State var supersetToUse: Superset?
    @State private var selectedSupersetExercise: Int = 0
    @State private var noPlan = false
    @EnvironmentObject private var networkManager: InternetConnectionManager
    
    var body: some View {
        
        VStack {

            ScrollView(showsIndicators:false) {
                SingleSupersetStatsDetailView(superset: self.supersetToUse, noPlan: self.$noPlan)
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                Picker("Exercise", selection: self.$selectedSupersetExercise, content: {
                    ForEach(self.supersets.indices, id:\.self) { index in
                        Text("Exercise \(index + 1)").tag(index)
                        
                    }
                })
                    .pickerStyle(.segmented)
                
            }
            .padding(30)
        }
        .onChange(of: self.selectedSupersetExercise, perform: { newValue in
            self.supersetToUse = self.supersets[newValue]
        })
        .onAppear {
            let supersetDB = self.exercise.supersets?.allObjects as? [Superset] ?? [Superset]()
            let supersetDBSorted = supersetDB.sorted(by: { $0.exerciseOrder < $1.exerciseOrder})
            for superset in supersetDBSorted {
                self.supersets.append(superset)
            }
            self.supersetToUse = self.supersets[self.selectedSupersetExercise]
            
            guard let coach = coach else {
                return
            }
            
            guard let userid = userid else {
                return
            }

            guard let token = token else {
                return
            }

            
            ApiManager().checkPlanExistence(userid: userid, token: token, planName: self.exercise.plan?.name ?? "", coach: coach) { result in
                switch (result) {
                case .success(let response):
                    if (response.message != nil && response.message == "Plan found") {
                        
                    } else {
                        self.noPlan = true
                    }
                case .failure(let networkingError):
                    print(networkingError.localizedDescription)
                }
            }
        }
    }
}

