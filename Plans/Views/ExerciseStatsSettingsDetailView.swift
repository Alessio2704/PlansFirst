//
//  ExerciseStatsSettingsDetailView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 03/05/22.
//

import SwiftUI

struct ExerciseStatsSettingsDetailView: View {
    
    let stat: StatDownloadApi
    let formattedDate: String
    var body: some View {
        VStack {
            ForEach(self.stat.sets, id: \.number) { setApiObj in
                Text("#\(setApiObj.number) Set  \(setApiObj.reps) reps - \(setApiObj.weight) kg")
                    .frame(width: 250)
                    .padding()
                    .overlay(Rectangle().strokeBorder(.secondary))
            }
            Spacer()
        }
        .padding()
        .navigationTitle(self.formattedDate)
    }
}
