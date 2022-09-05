//
//  EditExerciseView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 25/02/22.
//

import SwiftUI

struct EditExerciseView: View {
    
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    let exercise: Exercise
    let dimension = UIScreen.main.bounds.width - 50
    let previousExerciseModel: ExerciseModel
    @StateObject var exerciseModel =  ExerciseModel()
    @EnvironmentObject private var networkManager: InternetConnectionManager
    @Environment(\.dismiss) var dismiss
    @State private var isPlanOnline = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    HStack {
                        Text("Add Set")
                        
                        Spacer()
                        
                        Button(action: {
                            self.exerciseModel.sets.append(SetModel())
                        }, label: {
                            Image(systemName: "plus")
                                .frame(width: 40, height: 40)
                                .background(.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .padding(15)
                        })
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading) {
                        
                        LegendViewEditExerciseSets()
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 15) {
                                ForEach(self.exerciseModel.sets.indices, id:\.self) { index in
                                    AddExerciseSetView(edit: true, index: index, exerciseModel: self.exerciseModel, setModelView: self.exerciseModel.sets[index])
                                }
                            }
                        }
                    }
                    .frame(width: dimension, height: dimension + 100)
                    .onAppear {
                        self.exerciseModel.name = self.previousExerciseModel.name
                        for setModel in self.previousExerciseModel.sets {
                            self.exerciseModel.sets.append(setModel)
                        }
                    }
                    
                    Button {
                        
                        if (self.isPlanOnline) {
                            guard let userid = userid else {
                                return
                            }
                            
                            guard let token = token else {
                                return
                            }
                            
                            guard let coach = coach else {
                                return
                            }
                            
                            var setApiArray = [SetApi]()
                        
                            for index in self.exerciseModel.sets.indices {
                                
                                var setApi = SetApi()
                                setApi.reps = Int(self.exerciseModel.sets[index].reps) ?? 0
                                setApi.weight = self.exerciseModel.sets[index].weight
                                setApi.number = Int(index + 1)
                                setApi.restTime = Int(self.exerciseModel.sets[index].restTime) ?? 0
                                setApiArray.append(setApi)
                            }
                            
                            let apiStruct = addExerciseApiModel(planName: self.exercise.plan?.name ?? "", exerciseName: self.exercise.name ?? "", day: self.exercise.day ?? "", sets: setApiArray, rowOrder: Int(self.exercise.rowOrder))
                            
                            ApiManager().updateExercise(userid: userid, token: token, coach: coach, apiStruct: apiStruct) { result in
                                switch (result) {
                                case .success(let authRespone):
                                    print(authRespone.message ?? "")
                                    CoreDataManager().updateExerciseSets(exercise: self.exercise, exerciseModel: self.exerciseModel)
                                    dismiss()
                                case .failure(let networkingError):
                                    print(networkingError.localizedDescription)
                                    CoreDataManager().updateExerciseSets(exercise: self.exercise, exerciseModel: self.exerciseModel)
                                    dismiss()
                                }
                            }
                        } else {
                            CoreDataManager().updateExerciseSets(exercise: self.exercise, exerciseModel: self.exerciseModel)
                            dismiss()
                        }

                        
                    } label: {
                        Text("Save")
                            .padding()
                            .background(Color(uiColor: UIColor.secondarySystemFill))
                            .cornerRadius(20)
                            .foregroundColor(.primary)
                        
                    }
                    
                }
                .navigationTitle(Text(self.previousExerciseModel.name))
            .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                
                if (self.networkManager.isActive) {
                    guard let userid = userid else {
                        return
                    }
                    
                    guard let token = token else {
                        return
                    }
                    
                    guard let coach = coach else {
                        return
                    }
                    ApiManager().checkPlanExistence(userid: userid, token: token, planName: self.exercise.plan?.name ?? "", coach: coach) { result in
                        switch (result) {
                        case .success(let response):
                            if (response.message != nil && response.message == "Plan found") {
                                self.isPlanOnline = true
                            } else if (response.message != nil && response.message == "No plan found") {
                                self.isPlanOnline = false
                            }
                        case .failure(let networkingError):
                            print(networkingError.localizedDescription)
                            self.isPlanOnline = false
                        }
                    }
                }
            }
        }
    }
}

//extension EditExerciseView {
//
//    func updateStats(apiStruct: addExerciseApiModel) {
//        guard let userid = userid else {
//            return
//        }
//
//        guard let token = token else {
//            return
//        }
//
//        guard let coach = coach else {
//            return
//        }
//
//        ApiManager().updateExercise(userid: userid, token: token, coach: coach, apiStruct: apiStruct) { result in
//            switch (result) {
//            case .success(let authRespone):
//                print(authRespone.message ?? "")
//            case .failure(let networkingError):
//                print(networkingError.localizedDescription)
//            }
//        }
//    }
//}
