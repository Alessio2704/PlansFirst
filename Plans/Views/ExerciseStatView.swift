//
//  ExerciseStatView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 07/02/22.
//

import SwiftUI
import SwiftUICharts
struct ExerciseStatView: View {
    
    let exercise: Exercise
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @State private var exerciseStats = [StatDownloadApi]()
    @State private var noData = false
    @State private var noPlan = false
    @State private var showStatsSettingsView = false
    @EnvironmentObject private var networkManager: InternetConnectionManager
    
    var body: some View {
        VStack {
            if (self.networkManager.isActive) {
                if (!self.exerciseStats.isEmpty) {
                    ScrollView {
                        VStack(spacing: 40) {
                            
                            LineChartView(data: StatsCalculator().calcWeightsArray(exerciseStats: self.exerciseStats), title: "Max Weight", form: ChartForm.extraLarge, rateValue: 0)
                                .padding(.top)
                            
                            LineChartView(data: StatsCalculator().calcVolumeArray(exerciseStats: self.exerciseStats), title: "Volume", form: ChartForm.extraLarge, rateValue: 0)
                                .padding(.top)
                            
                            LineChartView(data: StatsCalculator().calcFrequencyArray(exerciseStats: self.exerciseStats), title: "Frequency", form: ChartForm.extraLarge, rateValue: 0)
                        }
                        .padding(.horizontal)
                    }
                } else if (self.noPlan) {
                    Text("Upload the plan first in order to save and get exercises stats")
                        .font(.title3)
                        .foregroundColor(.secondary)
                } else if (!self.noData) {
                    ProgressView()
                } else if (self.noData) {
                    Text("No stats yet")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("No internet connection")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear(perform: {
            
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
                        ApiManager().downloadStats(exercise: self.exercise, userid: self.userid, token: self.token, coach: coach) { result in
                            switch (result) {
                            case .success(let statsArray):
                                DispatchQueue.main.async {
                                    if (statsArray.isEmpty) {
                                        self.noData.toggle()
                                    }
                                    self.exerciseStats = statsArray
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    } else {
                        self.noPlan = true
                    }
                case .failure(let networkingError):
                    print(networkingError.localizedDescription)
                }
            }
        })
        .navigationTitle(Text("Stats"))
        .toolbar {
            Button {
                self.showStatsSettingsView.toggle()
            } label: {
                Image(systemName: "gear")
            }
        }
        .fullScreenCover(isPresented: self.$showStatsSettingsView) {
            ExerciseStatsSettingsView(exerciseStats: self.exerciseStats)
        }
    }
}
 
