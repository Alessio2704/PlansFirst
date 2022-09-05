//
//  AddExerciseSetsView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct AddExerciseView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var filter:String
    var exercises: FetchedResults<Exercise>
    @State var selectedExerciseType = "exercise"
    let dimension = UIScreen.main.bounds.width - 50
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .padding(.trailing)
            }
            
            Picker("Exercise Type", selection: self.$selectedExerciseType) {
                Text("Exercise").tag("exercise")
                Text("Superset").tag("superset")
            }
            .padding(.top)
            .pickerStyle(.segmented)
            
            if (self.selectedExerciseType == "exercise") {
                AddExerciseModelView(filter: self.filter, exercises: self.exercises)
            } else if (self.selectedExerciseType == "superset") {
                AddSupersetView(filter: self.filter, exercises: self.exercises)
            }
        }

    }
}

