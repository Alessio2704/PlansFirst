//
//  StatsSettingsView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 03/05/22.
//

import SwiftUI

struct ExerciseStatsSettingsView: View {
    
    let dateFormatter1 = ISO8601DateFormatter()
    let dateFormatter2 = DateFormatter()
    @Environment(\.dismiss) var dismiss
    
    
    var exerciseStats: [StatDownloadApi]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.exerciseStats) { stat in
                    NavigationLink {
                        ExerciseStatsSettingsDetailView(stat: stat, formattedDate: dateFormatter2.string(from: dateFormatter1.date(from: stat.date) ?? Date()))
                    } label: {
                        Text(dateFormatter2.string(from: dateFormatter1.date(from: stat.date) ?? Date()))
                    }
                }
            }
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }

            }
            .navigationTitle("Stats Report")
        }
    }
    
    init(exerciseStats: [StatDownloadApi]) {
        dateFormatter1.formatOptions.insert(.withFractionalSeconds)
        dateFormatter1.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        self.exerciseStats = exerciseStats
    }
}





