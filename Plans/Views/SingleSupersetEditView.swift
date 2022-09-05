//
//  SingleSupersetEditView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 03/05/22.
//

import SwiftUI

struct SingleSupersetEditView: View {
    
    @StateObject var exerciseSupersetModel: ExerciseSupersetModel
    let dimension = UIScreen.main.bounds.width - 50
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text(self.exerciseSupersetModel.name)
                    .font(.title3)
                
                HStack {
                    Text("Add Set")
                    
                    Spacer()
                    
                    Button {
                        let newSet = SetModelSuperset()
                        newSet.number = (self.exerciseSupersetModel.sets.last?.number ?? 0) + 1
                        self.exerciseSupersetModel.sets.append(newSet)
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 40, height: 40)
                            .background(.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .padding(15)
                    }
                }
                
                VStack(alignment: .leading) {
                    LegendViewEditSupersetView()
                    ScrollView(showsIndicators: false) {
                        ForEach(self.exerciseSupersetModel.sets.indices, id:\.self) { index in
                            AddSupersetSetsView(edit: true, index: index, exerciseSupersetModel: self.exerciseSupersetModel, setModelSupersetView: self.exerciseSupersetModel.sets[index])
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(width: dimension, height: dimension + 100)
    }
}

