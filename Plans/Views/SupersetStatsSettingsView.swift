//
//  SupersetStatsSettingsView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 03/05/22.
//

import SwiftUI

struct SupersetStatsSettingsView: View {
    let dateFormatter1 = ISO8601DateFormatter()
    let dateFormatter2 = DateFormatter()
    @Environment(\.dismiss) var dismiss
    
    
    var supersetStats: [StatsSupersetApiResult]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.supersetStats, id: \.id) { stat in
                    NavigationLink {
                        SupersetStatsSettingsDetailView(stat: stat, formattedDate: dateFormatter2.string(from: dateFormatter1.date(from: stat.date) ?? Date()))
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
    
    init(supersetStats: [StatsSupersetApiResult]) {
        dateFormatter1.formatOptions.insert(.withFractionalSeconds)
        dateFormatter1.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        dateFormatter2.dateFormat = "MMM d YYYY"
        self.supersetStats = supersetStats
    }
}
