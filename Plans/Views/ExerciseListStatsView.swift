//
//  ExerciseListStatsView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 07/02/22.
//

import SwiftUI

struct ExerciseListStatsView: View {
    
    @FetchRequest(entity: Exercise.entity(), sortDescriptors: [], animation: .default) private var exercises: FetchedResults<Exercise>
    
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(self.exercises.filter({ self.searchText.isEmpty ? true : $0.name!.localizedCaseInsensitiveContains(self.searchText) })) { exercise in
                NavigationLink {
                    ExerciseStatsDetailView(exercise: exercise)
                } label: {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("\(exercise.name ?? "")")
                            .font(.title3)
                        HStack {
                            Text("\(exercise.day ?? "")")
                            Text("\(exercise.plan?.name ?? "")")
                            Spacer()
                        }
                        .font(.footnote)
                    }
                }
            }
        }
        .searchable(text: self.$searchText)
        .padding(.top)
        .navigationTitle(Text("Exercises"))
    }
}
