//
//  EditSupersetView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 03/05/22.
//

import SwiftUI

struct EditSupersetView: View {
    
    let exercise: Exercise
    let modelsArray: [ExerciseSupersetModel]
    let exerciseNuber: Int
    @State private var modelsArrayToSave = [ExerciseSupersetModel]()
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @StateObject var supersetModel1 = ExerciseSupersetModel(exerciseOrder: 1)
    @StateObject var supersetModel2 = ExerciseSupersetModel(exerciseOrder: 2)
    @StateObject var supersetModel3 = ExerciseSupersetModel(exerciseOrder: 3)
    @StateObject var supersetModel4 = ExerciseSupersetModel(exerciseOrder: 4)
    @State private var restTime = 30.0
    @State private var exerciseSelected = 0
    @EnvironmentObject private var networkManager: InternetConnectionManager
    @Environment(\.dismiss) var dismiss
    @State private var isPlanOnline = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Stepper("Rest Time \(self.restTime, specifier: "%.0f") sec", value: self.$restTime, in: (30.0 ... 300), step: 10.0)
            Picker("Exercises", selection: self.$exerciseSelected, content: {
                ForEach(0 ..< self.exerciseNuber, id:\.self) { num in
                    Text("Exercise \(num + 1)").tag(num)
                }
            })
            .pickerStyle(.segmented)
            .padding(.bottom)
            
            switch (self.exerciseSelected) {
            case 0:
                SingleSupersetEditView(exerciseSupersetModel: self.supersetModel1)
            case 1:
                SingleSupersetEditView(exerciseSupersetModel: self.supersetModel2)
            case 2:
                SingleSupersetEditView(exerciseSupersetModel: self.supersetModel3)
            case 3:
                SingleSupersetEditView(exerciseSupersetModel: self.supersetModel4)
            default:
                EmptyView()
            }
            
            Spacer()
            
            Button {
                
                switch (self.exerciseNuber) {
                case 2:
                    self.modelsArrayToSave.append(self.supersetModel1)
                    self.modelsArrayToSave.append(self.supersetModel2)
                case 3:
                    self.modelsArrayToSave.append(self.supersetModel1)
                    self.modelsArrayToSave.append(self.supersetModel2)
                    self.modelsArrayToSave.append(self.supersetModel3)
                case 4:
                    self.modelsArrayToSave.append(self.supersetModel1)
                    self.modelsArrayToSave.append(self.supersetModel2)
                    self.modelsArrayToSave.append(self.supersetModel3)
                    self.modelsArrayToSave.append(self.supersetModel4)
                default:
                    print("")
                }
                
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
                    
                    var addSupersetApiModel = addSupersetApiModel()
                    
                    addSupersetApiModel.exerciseName = "Superset"
                    addSupersetApiModel.planName = self.exercise.plan?.name ?? ""
                    addSupersetApiModel.exerciseOrder = Int(self.exercise.rowOrder)
                    addSupersetApiModel.restTime = Int(self.exercise.restTime)
                    addSupersetApiModel.day = self.exercise.day ?? ""
                    
                    for supersetModel in self.modelsArrayToSave {
                        var supersetApi = SupersetApi()
                        supersetApi.exerciseName = supersetModel.name
                        supersetApi.exerciseOrder = supersetModel.exerciseOrder
                        
                        for setModel in supersetModel.sets {
                            
                            var setSupersetApi = SetSupersetApi()
                            setSupersetApi.number = setModel.number
                            setSupersetApi.reps = Int(setModel.reps) ?? 0
                            setSupersetApi.weight = setModel.weight
                            setSupersetApi.latestReps = Int(setModel.latestReps) ?? 0
                            
                            supersetApi.sets.append(setSupersetApi)
                        }

                        addSupersetApiModel.supersets.append(supersetApi)
                    }
                    
                    ApiManager().updateSuperset(userid: userid, token: token, coach: coach, apiStruct: addSupersetApiModel) { result in
                        
                        switch (result) {
                        case .success(let authRespone):
                            print(authRespone.message ?? "")
                            updateSupersetDB()
                            
                        case .failure(let networkingError):
                            print(networkingError.localizedDescription)
                            updateSupersetDB()
                        }
                    }
                    
                } else {
                    updateSupersetDB()
                }
                
            } label: {
                Text("Save")
                    .padding()
                    .background(Color(uiColor: UIColor.secondarySystemFill))
                    .cornerRadius(20)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        
        .onAppear {
            
            self.restTime = Double(self.exercise.restTime)
            
            switch (self.modelsArray.count) {
            case 2:
                self.supersetModel1.name = self.modelsArray[0].name
                self.supersetModel1.sets = self.modelsArray[0].sets
                self.supersetModel2.name = self.modelsArray[1].name
                self.supersetModel2.sets = self.modelsArray[1].sets
            case 3:
                self.supersetModel1.name = self.modelsArray[0].name
                self.supersetModel1.sets = self.modelsArray[0].sets
                self.supersetModel2.name = self.modelsArray[1].name
                self.supersetModel2.sets = self.modelsArray[1].sets
            case 4:
                self.supersetModel1.name = self.modelsArray[0].name
                self.supersetModel1.sets = self.modelsArray[0].sets
                self.supersetModel2.name = self.modelsArray[1].name
                self.supersetModel2.sets = self.modelsArray[1].sets
                self.supersetModel3.name = self.modelsArray[2].name
                self.supersetModel3.sets = self.modelsArray[2].sets
                self.supersetModel4.name = self.modelsArray[3].name
                self.supersetModel4.sets = self.modelsArray[3].sets
            default:
                print("Default Edit Superset View Switch")
            }
            
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

extension EditSupersetView {
    func updateSupersetDB() {
        CoreDataManager.shared.updateRestTimeSuperset(id: self.exercise.id ?? UUID(), restTime: Int64(self.restTime))
        
        for modelToSave in self.modelsArrayToSave {
            CoreDataManager.shared.editSingleSupersetExerciseSets(exercise: self.exercise,supersetModel: modelToSave)
        }
        
        dismiss()
    }
}

