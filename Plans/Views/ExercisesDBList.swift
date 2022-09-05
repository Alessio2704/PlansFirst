//
//  ExercisesDBList.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 10/02/22.
//

import SwiftUI

struct ExercisesDBList: View {
    
    @Environment(\.dismiss) var dismiss
    @State var publicExercisesModel = [publicExercise]()
    @State var searchText = ""
    @Binding var exerciseName: String
    
    var body: some View {
        
        NavigationView {
            
            if (self.publicExercisesModel.isEmpty) {
                
                VStack {
                    HStack {
                        Text("Loading exercises ...")
                            .padding()
                        ProgressView()
                    }
                    Spacer()
                }
            } else {
                List {
                    ForEach(self.filteredArray, id: \.self) { ex in
                        Button {
                            self.exerciseName = ex.exerciseName
                            dismiss()
                        } label: {
                            Text(ex.exerciseName)
                                .foregroundColor(.primary)
                        }

                    }
                }
                .searchable(text: $searchText)
                .navigationTitle(Text("Exercises"))
                .toolbar {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
        .onAppear {
            ApiManager().fetchPublicExercises { exercisesArrayFetched in
                self.publicExercisesModel = exercisesArrayFetched.sorted(by: { $0.exerciseName < $1.exerciseName })
            }
        }
    }
    
    var filteredArray: [publicExercise] {
        
        if (self.searchText == "") {
            return publicExercisesModel
        } else {
            return publicExercisesModel.filter { $0.exerciseName.localizedCaseInsensitiveContains(self.searchText) }
        }
    }
}
