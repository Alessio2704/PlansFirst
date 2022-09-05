//
//  SupersetDetailView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 09/02/22.
//

import SwiftUI

struct SupersetDetailView: View {
    
    let exercise: Exercise
    @State var arraySupersetModel = [ExerciseSupersetModel]()
    @Environment(\.scenePhase) var scene
    @EnvironmentObject private var networkManager: InternetConnectionManager
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @State private var statsAlerMessage = ""
    @State private var showStatsUploadAlert = false
    @State private var saved = false
    @State private var planIsInCloud = false
    @State private var showTimerView = false
    @State private var areStatsOn = false
    @State var start:Bool = false
    @State var to:CGFloat = 1
    @State var count:Double = 0.0
    @State var exitTime = Date()
    @State var diff = 0.0
    @State private var editSuperset = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.arraySupersetModel) { superset in
                            SupersetExerciseDetailView(exerciseSupersetModel: superset)
                        }
                    }
                }
                
                if (!self.saved) {
                    Button {
                        CoreDataManager.shared.updateAllSupersetExercisesSets(exerciseSupersetModelArray: self.arraySupersetModel)
                        self.saved = true
                        
                        if (self.planIsInCloud) {
                            guard let coach = coach else {
                                return
                            }
                            
                            ApiManager().uploadSupersetStats(exercise: self.exercise, exerciseSupersetModelArray: self.arraySupersetModel, userid: self.userid, token: self.token, coach: coach) { result in
                                switch (result) {
                                case .success(_):
                                    self.statsAlerMessage = "Superset stats uploaded succesfully"
                                    self.showStatsUploadAlert = true
                                case .failure(let networkingError):
                                    print(networkingError.localizedDescription)
                                }
                            }
                        }
                        
                    } label: {
                        Text("Save")
                            .frame(width: 200)
                            .padding()
                            .background(Color(uiColor: UIColor.secondarySystemFill))
                            .foregroundColor(.primary)
                            .cornerRadius(20)
                        
                    }
                    .padding(20)
                }
            }
            .toolbar {
                HStack {
                    Button {
                        self.editSuperset.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    
                    Button {
                        self.showTimerView.toggle()
                    } label: {
                        Image(systemName: "stopwatch")
                    }
                }
            }
            .onAppear {

                if (self.arraySupersetModel.isEmpty) {
                    let supersetArrayDB = self.exercise.supersets?.allObjects as? [Superset] ?? [Superset]()
                    let supersetArrayDBToUse = supersetArrayDB.sorted(by: { $0.exerciseOrder < $1.exerciseOrder})
                    
                    for index in supersetArrayDBToUse.indices {
                        @ObservedObject var supersetModel = ExerciseSupersetModel(exerciseOrder: index + 1)
                        supersetModel.name = supersetArrayDBToUse[index].exerciseName ?? ""
                        supersetModel.exerciseOrder = Int(supersetArrayDBToUse[index].exerciseOrder)
                        supersetModel.day = self.exercise.day ?? ""
                        supersetModel.id = supersetArrayDBToUse[index].id!
                        let supersetSetsArrayDB = supersetArrayDBToUse[index].sets?.allObjects as? [SetExercise] ?? [SetExercise]()
                        let supersetSetsArrayDBToUse = supersetSetsArrayDB.sorted(by: { $0.number < $1.number })
                        for indexOfSets in supersetSetsArrayDBToUse.indices {
                            @ObservedObject var setModelSuperset = SetModelSuperset()
                            setModelSuperset.id = supersetSetsArrayDBToUse[indexOfSets].id!
                            setModelSuperset.reps = String(supersetSetsArrayDBToUse[indexOfSets].reps)
                            setModelSuperset.weight = String(supersetSetsArrayDBToUse[indexOfSets].weight)
                            setModelSuperset.latestReps = String(supersetSetsArrayDBToUse[indexOfSets].latestReps)
                            supersetModel.sets.append(setModelSuperset)
                        }
                        self.arraySupersetModel.append(supersetModel)
                    }
                }
                
                guard let userid = userid else {
                    return
                }
                guard let token = token else {
                    return
                }
                guard let coach = coach else {
                    return
                }
                
                
                if (self.networkManager.isActive) {
                    ApiManager().checkPlanExistence(userid: userid, token: token, planName: self.exercise.plan?.name ?? "", coach: coach) { result in
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
            .sheet(isPresented: self.$showTimerView) {
                TimerView(exerciseName: "Superset", time: Double(self.exercise.restTime), start: self.$start, to: self.$to, count: self.$count, exitTime: self.$exitTime, diff: self.$diff )
                    .onChange(of: scene) { newScene in
                        if (newScene == .background) {
                            self.exitTime = Date()
                        }
                        
                        if (newScene == .active) {
                            withAnimation {
                                self.diff = Date().timeIntervalSince(self.exitTime)
                            }
                            if (self.start) {
                                if (self.count > Double(self.diff)) {
                                    withAnimation {
                                        self.count -= Double(self.diff)
                                        self.to = CGFloat(self.count/Double(self.exercise.restTime))
                                    }
                                } else {
                                    withAnimation {
                                        self.count = Double(self.exercise.restTime)
                                        self.to = 1
                                        self.start = false
                                    }
                                }
                            }
                        }
                    }
            }
            .alert(self.statsAlerMessage, isPresented: self.$showStatsUploadAlert) {
                Button("OK", role: .cancel, action: {
                    
                })
            }
            .sheet(isPresented: self.$editSuperset) {
                EditSupersetView(exercise: self.exercise, modelsArray: self.arraySupersetModel, exerciseNuber: self.exercise.supersets?.count ?? 0)
        }
        }
    }
}

