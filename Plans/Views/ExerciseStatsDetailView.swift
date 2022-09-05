//
//  ExerciseStatsDetailView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 01/03/22.
//

import SwiftUI

struct ExerciseStatsDetailView: View {
    let exercise:Exercise
    var body: some View {
        
        if (self.exercise.name == "Superset") {
            SupersetStatView(exercise: self.exercise)
        } else {
            ExerciseStatView(exercise: self.exercise)
        }
    }
}
