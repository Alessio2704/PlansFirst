//
//  ExerciseDetailView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct ExerciseDetailView: View {
    
    @FetchRequest private var exercises: FetchedResults<Exercise>
    @EnvironmentObject var currentPlanManager: CurrentPlanManager
    let exercise: Exercise
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @StateObject var exerciseModel = ExerciseModel()
    @EnvironmentObject var pickerManager: showPickerManager
    @EnvironmentObject private var networkManager: InternetConnectionManager
    @State private var areStatsOn = false
    @State private var statsAlerMessage = ""
    @State private var showStatsUploadAlert = false
    @State private var saved = false
    @State private var isEditing = false
    @State private var isWritingNotes = false
    @State var newNotes = ""
    
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        Text(self.exercise.name ?? "")
                            .font(.body)
                    }
                    
                    VStack(spacing: 10) {
                        LegendViewExerciseSets()
                        
                        ForEach(self.exerciseModel.sets.indices, id:\.self) { index in
                            SetsViewDetailView(exerciseModel: self.exerciseModel, indexNum: index)
                        }
                    }
                    .padding()
                }
                .frame(width: 350, height: 400)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(30)
                .shadow(color: .gray, radius: 10)
                .padding()
                
                if (!self.saved) {
                    Button {
                        saveButtonAction()
                    } label: {
                        Text("Save")
                            .frame(width: 200)
                            .padding()
                            .background(Color(uiColor: UIColor.secondarySystemFill))
                            .foregroundColor(.primary)
                            .cornerRadius(20)
                        
                    }
                    .padding(.top,30)
                }
                
            }
        }
        .toolbar {
            HStack {
                Button {
                    self.isEditing.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                
                Button {
                    self.newNotes = self.exercise.notes ?? ""
                    self.isWritingNotes.toggle()
                } label: {
                    Image(systemName: "note.text")
                }
            }
        }
        .onAppear {
            self.pickerManager.showPicker = false
            if (self.exerciseModel.sets.isEmpty) {
                self.exerciseModel.name = self.exercise.name ?? ""
                self.exerciseModel.day = self.exercise.day ?? ""
                self.exerciseModel.id = UUID()
                let exerciseCoreDataSets = self.exercise.sets?.allObjects as? [SetExercise] ?? [SetExercise]()
                for coreDataSet in exerciseCoreDataSets {
                    let setModel = SetModel()
                    setModel.reps = String(coreDataSet.reps)
                    setModel.weight = String(coreDataSet.weight)
                    setModel.restTime = String(coreDataSet.restTime)
                    setModel.latestReps = String(coreDataSet.latestReps)
                    setModel.number = Int(coreDataSet.number)
                    setModel.id = coreDataSet.id!
                    self.exerciseModel.sets.append(setModel)
                }
                self.exerciseModel.sets = self.exerciseModel.sets.sorted(by: { $0.number < $1.number })
            }
        }
        .onDisappear(perform: {
            withAnimation {
                self.pickerManager.showPicker = true
            }
        })
        .alert(self.statsAlerMessage, isPresented: self.$showStatsUploadAlert) {
            Button("OK", role: .cancel, action: {
                
            })
        }
        .sheet(isPresented: self.$isEditing) {
            EditExerciseView(exercise: self.exercise, previousExerciseModel: self.exerciseModel)
        }
        .sheet(isPresented: self.$isWritingNotes) {
            ExerciseNotesView(exercise: self.exercise, exerciseNotes: self.$newNotes)
        }
    }
    
    init(exercise: Exercise) {
        
        self.exercise = exercise
        _exercises = FetchRequest<Exercise>(sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.rowOrder,ascending: true)], predicate: NSPredicate(format: "plan.name BEGINSWITH %@", exercise.plan?.name ?? ""), animation: .default)
    }
}


extension ExerciseDetailView {
    
    func saveButtonAction() {
        
        guard let coach = coach else { return }
        
        CoreDataManager.shared.updateExerciseSet(exerciseModel: self.exerciseModel)
        
        if (self.networkManager.isActive) {
            ApiManager().uploadStats(exercise: self.exercise, exerciseModel: self.exerciseModel, exercises: self.exercises, userid: self.userid, token: self.token, coach: coach) { result in
                switch (result) {
                case .success(_):
                    self.statsAlerMessage = "Exercise stats uploaded succesfully"
                    self.showStatsUploadAlert = true
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        self.saved = true
    }
}
