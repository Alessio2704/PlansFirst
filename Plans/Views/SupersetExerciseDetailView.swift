//
//  SupersetExerciseDetailView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 09/02/22.
//

import SwiftUI

struct SupersetExerciseDetailView: View {
    
    @StateObject var exerciseSupersetModel: ExerciseSupersetModel

    
    var body: some View {
        VStack(spacing: 10) {
            VStack {
                Text(self.exerciseSupersetModel.name)
                    .font(.title3)
                    .padding()
                
                VStack(spacing: 10) {
                    LegendViewSupersetView()
                        
                    ForEach(self.exerciseSupersetModel.sets.indices, id:\.self) { index in
                        SetsViewDetailViewSuperset(indexNum: index, exerciseSupersetModel: self.exerciseSupersetModel)
                    }
                }
                .font(.body)
            }
        }
        .frame(width: 350, height: 400)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(30)
        .shadow(color: .gray, radius: 10)
        .padding()
    }
}
