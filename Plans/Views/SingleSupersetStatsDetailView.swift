//
//  SingleSupersetStatsDetailView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 01/03/22.
//

import SwiftUI
import SwiftUICharts

struct SingleSupersetStatsDetailView: View {
    
    var superset: Superset?
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @State private var supersetStats = [StatsSupersetApiResult]()
    @State private var repsArray = [Double]()
    @State private var weightsArray = [Double]()
    @State private var noData = false
    @State private var showSupersetStatsView = false
    @Binding var noPlan: Bool
    @EnvironmentObject private var networkManager: InternetConnectionManager
    
    var body: some View {
        VStack {
            if (self.networkManager.isActive) {
                if (!self.supersetStats.isEmpty) {
                    ScrollView {
                        VStack(spacing: 40) {
                            
                            LineChartView(data: StatsCalculatorSupersets().calcWeightsArray(supersetStats: self.supersetStats), title: "Max Weight", form: ChartForm.extraLarge, rateValue: 0)
                                .padding(.top)
                            
                            LineChartView(data: StatsCalculatorSupersets().calcVolumeArray(supersetStats: self.supersetStats), title: "Volume", form: ChartForm.extraLarge, rateValue: 0)
                                .padding(.top)
                        }
                        .padding(.horizontal)
                    }
                } else if (self.noPlan) {
                    Text("Upload the plan first in order to save and get exercises stats")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.top,30)
                } else if (!self.noData) {
                    HStack(spacing: 10) {
                        Text("Loading ...")
                        ProgressView()
                    }
                    .padding(.top,200)
                } else if (self.noData) {
                    Text("No stats yet")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.top,30)
                }
            } else {
                Text("No internet connection")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(.top,30)
            }
        }
        .toolbar {
            Button {
                self.showSupersetStatsView.toggle()
            } label: {
                Image(systemName: "gear")
            }

        }
        .onChange(of: self.superset, perform: { newValue in
            guard let coach = coach else {
                return
            }
            ApiManager().downloadSupersetStats(superset: newValue! , userid: self.userid, token: self.token, coach: coach) { result in
                switch (result) {
                case .success(let statsArray):
                    if (statsArray.isEmpty) {
                        self.noData = true
                    } else {
                        self.supersetStats = statsArray
                    }
                case .failure(let networkingError):
                    print(networkingError.localizedDescription)
                    self.noData = true
                }
            }
            
        })
        .navigationTitle(Text("Stats"))
        .fullScreenCover(isPresented: self.$showSupersetStatsView) {
            SupersetStatsSettingsView(supersetStats: self.supersetStats)
        }
    }
}

