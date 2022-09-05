//
//  FilteredListView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct FilteredList: View {
    
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var networkManager: InternetConnectionManager
    @EnvironmentObject var currentPlanManager: CurrentPlanManager
    @EnvironmentObject var pickerManager: showPickerManager
    @FetchRequest private var exercises: FetchedResults<Exercise>
    @State private var addExerciseIsPresented = false
    @State private var deleteDisabled = false
    @State private var showDeleteAlert = false
    @State private var indexSetExerciseToDelete = IndexSet()
    var filter:String
    var filter2:String
    
    
    var body: some View {
        NavigationView {
            VStack {
                if (self.currentPlanManager.isCurrentPlan.isEmpty) {
                    VStack {
                        Text("No plan selected")
                            .font(.title)
                            .foregroundColor(.secondary)
                            .padding()
                        Text("Go to plans \(Image(systemName: "list.dash")) to create or select a plan")
                        Spacer()
                    }
                } else {
                    if(self.exercises.isEmpty) {
                        VStack(alignment:.center) {
                            VStack {
                                Text("This workout day")
                                Text("has no exercises yet")
                            }
                            .font(.largeTitle)
                            .padding()
                            Spacer()
                            Text("To add an exercise tap on the \(Image(systemName: "plus")) icon")
                                .foregroundColor(.secondary)
                                .padding()
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(exercises, id:\.self) { exercise in
                                NavigationLink {
                                    FilteredExerciseDetailView(exercise: exercise)
                                } label: {
                                    Text(exercise.name ?? "")
                                    
                                }
                            }
                            .onDelete { IndexSet in
                                
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
                                                self.indexSetExerciseToDelete = IndexSet
                                                self.showDeleteAlert.toggle()
                                            } else if (response.message != nil && response.message == "No plan found") {
                                                CoreDataManager.shared.deleteExercise(at: IndexSet, exercises: self.exercises)
                                            }
                                        case .failure(let networkingError):
                                            print(networkingError.localizedDescription)
                                            CoreDataManager.shared.deleteExercise(at: IndexSet, exercises: self.exercises)
                                        }
                                    }
                                } else {
                                    CoreDataManager.shared.deleteExercise(at: IndexSet, exercises: self.exercises)
                                }
                           }
                            .onMove { IndexSet, Int in
                                CoreDataManager.shared.moveExercises(from: IndexSet, to: Int, exercises: self.exercises)
                            }
                            .deleteDisabled(self.deleteDisabled)
                            .listRowBackground(Color(red: 10/255, green: 140/255, blue: 245/255, opacity: 200/255))
                        }
                        .padding()
                        .toolbar {
                            EditButton()
                                .disabled(self.exercises.isEmpty)
                        }
                    }
                    
                    if (self.pickerManager.showPicker) {
                        Button {
                            self.addExerciseIsPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(.blue)
                        .clipShape(Capsule())
                    }
                }
                
            }
            .onAppear {
                UITableView.appearance().backgroundColor = self.colorScheme == .dark ? .black : .white
            }
            .padding(.top)
            .fullScreenCover(isPresented: self.$addExerciseIsPresented) {
                AddExerciseView(filter: self.filter, exercises: self.exercises)
            }
            .alert("Delete this exercise also from the cloud?", isPresented: self.$showDeleteAlert) {
                
                Button("No", action: {
                    CoreDataManager.shared.deleteExercise(at: self.indexSetExerciseToDelete, exercises: self.exercises)
                })
                
                Button("Yes", action: {
                    
                    guard let indexToUse = self.indexSetExerciseToDelete.first else { return }
                    
                    let exerciseToUse = self.exercises[indexToUse]
                    
                    guard let userid = userid else {
                        return
                    }
                    
                    guard let token = token else {
                        return
                    }
                    
                    guard let coach = coach else {
                        return
                    }
                    
                    ApiManager().deleteExercise(userid: userid, token: token, planName: self.currentPlanManager.isCurrentPlan.first?.name ?? "", coach: coach, exercise: exerciseToUse) { result in
                        
                        switch (result) {
                        case .success(let authRespone):
                            print(authRespone.message ?? "")
                            CoreDataManager.shared.deleteExercise(at: self.indexSetExerciseToDelete, exercises: self.exercises)
                        case .failure(let networkingError):
                            print(networkingError.localizedDescription)
                            CoreDataManager.shared.deleteExercise(at: self.indexSetExerciseToDelete, exercises: self.exercises)
                        }
                    }
                })
                
                Button("Cancel", action: {
                    
                })
            }
        }
    }
    
    init(filter:String,filter2:String) {
        
        let filterDay = NSPredicate(format: "day BEGINSWITH %@", filter)
        let filterPlan = NSPredicate(format: "plan.name BEGINSWITH %@", filter2)
        
        _exercises = FetchRequest<Exercise>(sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.rowOrder,ascending: true)], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [filterDay,filterPlan]), animation: .default)
        self.filter = filter
        self.filter2 = filter2
    }
}

