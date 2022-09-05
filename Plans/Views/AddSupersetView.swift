//
//  AddSupersetView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 08/02/22.
//

import SwiftUI

struct AddSupersetView: View {
    
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @ObservedObject var supersetExercisesArray = SupersetExercisesArray()
    @StateObject var supersetModel1 = ExerciseSupersetModel(exerciseOrder: 1)
    @StateObject var supersetModel2 = ExerciseSupersetModel(exerciseOrder: 2)
    @StateObject var supersetModel3 = ExerciseSupersetModel(exerciseOrder: 3)
    @StateObject var supersetModel4 = ExerciseSupersetModel(exerciseOrder: 4)
    @EnvironmentObject var currentPlanManager: CurrentPlanManager
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var networkManager: InternetConnectionManager
    var filter:String
    var exercises: FetchedResults<Exercise>
    @State var publicExercisesModel = [publicExercise]()
    let dimension = UIScreen.main.bounds.width - 50
    @State private var exerciseSupersetNumber = 2
    @State private var exerciseSupersetNumberView = 1
    @State private var selectRestTime = 30.0
    @State private var showSaveButton = false
    @State private var showSaveAlert = false
    @State private var planIsInCloud = false
    
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack (alignment: .center,spacing: 20) {
                    Stepper("Exercises Number \(self.exerciseSupersetNumber)", value: self.$exerciseSupersetNumber, in: ( 2 ... 4))
                    Divider()
                    
                    Stepper("Rest Time \(self.selectRestTime, specifier: "%.0f") sec", value: self.$selectRestTime, in: (30.0 ... 300), step: 10.0)
                    Divider()
                    
                    Picker("Exercises", selection: self.$exerciseSupersetNumberView, content: {
                        ForEach(0 ..< self.exerciseSupersetNumber, id:\.self) { num in
                            Text("Exercise \(num + 1)").tag(num + 1)
                        }
                    })
                        .pickerStyle(.segmented)
                        .padding(.bottom)
                    
                    Divider()
                }
                VStack {
                    switch (self.exerciseSupersetNumberView) {
                    case 1:
                        SingleExerciseSupersetView(exerciseSupersetModel: self.supersetModel1, exerciseNumberView: 1, filter: self.filter)
                            .environmentObject(self.supersetExercisesArray)
                    case 2:
                        SingleExerciseSupersetView(exerciseSupersetModel: self.supersetModel2, exerciseNumberView: 2, filter: self.filter)
                            .environmentObject(self.supersetExercisesArray)
                    case 3:
                        SingleExerciseSupersetView(exerciseSupersetModel: self.supersetModel3, exerciseNumberView: 3, filter: self.filter)
                            .environmentObject(self.supersetExercisesArray)
                    case 4:
                        SingleExerciseSupersetView(exerciseSupersetModel: self.supersetModel4, exerciseNumberView: 4, filter: self.filter)
                            .environmentObject(self.supersetExercisesArray)
                    default:
                        Text("Default")
                    }
                }
                
            }
            .padding(.top)
            
            Button {
                
                switch(self.exerciseSupersetNumber) {
                case 2:
                    self.supersetExercisesArray.arrayOfSupersetExercises.append(self.supersetModel1)
                    self.supersetExercisesArray.arrayOfSupersetExercises.append(self.supersetModel2)
                case 3:
                    self.supersetExercisesArray.arrayOfSupersetExercises.append(self.supersetModel1)
                    self.supersetExercisesArray.arrayOfSupersetExercises.append(self.supersetModel2)
                    self.supersetExercisesArray.arrayOfSupersetExercises.append(self.supersetModel3)
                case 4:
                    self.supersetExercisesArray.arrayOfSupersetExercises.append(self.supersetModel1)
                    self.supersetExercisesArray.arrayOfSupersetExercises.append(self.supersetModel2)
                    self.supersetExercisesArray.arrayOfSupersetExercises.append(self.supersetModel3)
                    self.supersetExercisesArray.arrayOfSupersetExercises.append(self.supersetModel4)
                default:
                    print("Default")
                }
                
                if (self.planIsInCloud == true) {
                    guard let coach = coach else {
                        return
                    }
                    
                    guard let token = token else {
                        return
                    }
                    
                    guard let userid = userid else {
                        return
                    }
                    
                    ApiManager().addSuperset(userid: userid, token: token, day: self.filter, planName: self.currentPlanManager.isCurrentPlan[0].name ?? "", coach: coach, exerciseSupersetArrayModel: self.supersetExercisesArray.arrayOfSupersetExercises, restTime: Int(self.selectRestTime), exercises: self.exercises) { result in
                        switch (result) {
                        case .success(let authRespone):
                            print(authRespone.message ?? "")
                            CoreDataManager().createSuperset(arrayOfExerciseModels: self.supersetExercisesArray.arrayOfSupersetExercises, exercises: self.exercises, day: self.filter, plan: self.currentPlanManager.isCurrentPlan[0], restTime: self.selectRestTime)
                            dismiss()
                        case .failure(let networkingError):
                            print(networkingError.localizedDescription)
                        }
                    }
                } else {
                    CoreDataManager().createSuperset(arrayOfExerciseModels: self.supersetExercisesArray.arrayOfSupersetExercises, exercises: self.exercises, day: self.filter, plan: self.currentPlanManager.isCurrentPlan[0], restTime: self.selectRestTime)
                    dismiss()
                }

            } label: {
                Text("Save Superset")
                    .frame(width: 200)
                    .padding()
                    .background(Color(uiColor: UIColor.secondarySystemFill))
                    .foregroundColor(.primary)
                    .cornerRadius(20)
            }
            
        }
        .padding()
        .onAppear {
            guard let coach = coach else {
                return
            }
            
            guard let token = token else {
                return
            }
            
            guard let userid = userid else {
                return
            }
            
            if (!self.currentPlanManager.isCurrentPlan.isEmpty && self.networkManager.isActive) {
                ApiManager().checkPlanExistence(userid: userid, token: token, planName: self.currentPlanManager.isCurrentPlan[0].name ?? "", coach: coach) { result in
                    switch (result) {
                    case .success(let response):
                        if (response.message != nil && response.message == "Plan found") {
                            self.planIsInCloud = true
                        } else if (response.message != nil && response.message == "No plan found") {
                            self.planIsInCloud = false
                        }
                    case .failure(let networkingError):
                        print(networkingError.localizedDescription)
                    }
                }
            }
        }
    }
}



