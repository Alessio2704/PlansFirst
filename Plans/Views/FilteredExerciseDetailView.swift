//
//  FilteredExerciseDetailView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 09/02/22.
//

import SwiftUI

struct FilteredExerciseDetailView: View {
    
    let exercise: Exercise
    @EnvironmentObject var pickerManager: showPickerManager
    
    var body: some View {
        VStack {
            if (self.exercise.name == "Superset") {
                SupersetDetailView(exercise: self.exercise)
            } else {
                ExerciseDetailView(exercise: exercise)
            }
        }
        .onAppear  {
            self.pickerManager.showPicker = false
        }
        .onDisappear {
            withAnimation {
                self.pickerManager.showPicker = true
            }
        }
    }
}

