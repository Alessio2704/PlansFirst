//
//  SingleExerciseSupersetView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 08/02/22.
//

import SwiftUI

struct SingleExerciseSupersetView: View {
    @EnvironmentObject var arrayOfExercisesModels: SupersetExercisesArray
    @StateObject var exerciseSupersetModel: ExerciseSupersetModel
    @EnvironmentObject var currentPlanManager: CurrentPlanManager
    let exerciseNumberView: Int
    @EnvironmentObject private var networkManager: InternetConnectionManager
    var filter:String
    @State private var showExercisesDBList = false
    let dimension = UIScreen.main.bounds.width - 50
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack (alignment: .leading) {
                    
                    HStack {
                        TextField("Exercise Name", text: self.$exerciseSupersetModel.name)
                            .textFieldStyle(.roundedBorder)
                        
                        if (self.networkManager.isActive) {
                            Image(systemName: "magnifyingglass")
                                .font(.title)
                                .onTapGesture {
                                    self.showExercisesDBList.toggle()
                                }
                        }
                    }
                }
                .padding(.top)
                
                VStack(alignment: .trailing) {
                    Button(action: {
                        let setModelSuperset = SetModelSuperset()
                        setModelSuperset.number = self.exerciseSupersetModel.sets.count + 1
                        self.exerciseSupersetModel.sets.append(setModelSuperset)
                    }, label: {
                        Image(systemName: "plus")
                            .frame(width: 40, height: 40)
                            .background(.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .padding([.trailing,.top],10)
                    })
                    ScrollView(showsIndicators: false) {
                        ForEach(self.exerciseSupersetModel.sets.indices, id:\.self) { index in
                            AddSupersetSetsView(edit: false, index: index, exerciseSupersetModel: self.exerciseSupersetModel, setModelSupersetView: self.exerciseSupersetModel.sets[index])
                        }
                    }
                }
                .padding(.vertical,30)
                .frame(width: dimension, height: dimension)
                
            }
        }
        .padding()
        .fullScreenCover(isPresented: self.$showExercisesDBList) {
            ExercisesDBList(exerciseName: self.$exerciseSupersetModel.name)
        }
    }
}

