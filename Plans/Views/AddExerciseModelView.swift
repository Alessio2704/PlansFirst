//
//  AddExerciseModelView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 08/02/22.
//

import SwiftUI

struct AddExerciseModelView: View {
    
    @AppStorage("userid") var userid: String?
    @AppStorage("token") var token: String?
    @AppStorage("coach") var coach: Bool?
    @EnvironmentObject var currentPlanManager: CurrentPlanManager
    @Environment(\.dismiss) var dismiss
    @StateObject var exerciseModel = ExerciseModel()
    @EnvironmentObject private var networkManager: InternetConnectionManager
    var filter:String
    var exercises: FetchedResults<Exercise>
    @State private var showAlertEmptyName = false
    @State private var showExercisesDBList = false
    @State var exerciseName = ""
    @State private var showSavingAlert = false
    @State private var planIsInCloud = false
    let dimension = UIScreen.main.bounds.width - 50
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack (alignment: .leading) {
                    
                    HStack {
                        TextField("Exercise Name", text: self.$exerciseName)
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
                        self.exerciseModel.sets.append(SetModel())
                    }, label: {
                        Image(systemName: "plus")
                            .frame(width: 40, height: 40)
                            .background(.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .padding([.trailing,.top],10)
                    })
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(self.exerciseModel.sets.indices, id:\.self) { index in
                                AddExerciseSetView(edit: false, index: index, exerciseModel: self.exerciseModel, setModelView: self.exerciseModel.sets[index])
                            }
                        }
                    }
                }
                .padding(.vertical,30)
                .frame(width: dimension, height: dimension + 100)
            
                
                
            }
            Button {
                if (self.exerciseName != "") {
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
                        
                        ApiManager().addExercise(userid: userid, token: token,exerciseName: self.exerciseName, day: self.filter, planName: self.currentPlanManager.isCurrentPlan[0].name ?? "", coach: coach, exercise: self.exerciseModel, exercises: self.exercises) { result in
                            switch (result) {
                            case .success(let authRespone):
                                print(authRespone.message ?? "")
                                CoreDataManager().createExercise(name: self.exerciseName, exerciseModel: self.exerciseModel, day: self.filter, plan: self.currentPlanManager.isCurrentPlan.first!, exercises: self.exercises)
                                dismiss()
                            case .failure(let networkingError):
                                print(networkingError.localizedDescription)
                            }
                        }
                    } else {
                        CoreDataManager().createExercise(name: self.exerciseName, exerciseModel: self.exerciseModel, day: self.filter, plan: self.currentPlanManager.isCurrentPlan.first!, exercises: self.exercises)
                        dismiss()
                    }
                } else {
                    self.showAlertEmptyName.toggle()
                }
                
            } label: {
                Text("Save Exercise")
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
        .alert(Text("Empty Name"), isPresented: self.$showAlertEmptyName) {
            Button(role: ButtonRole.cancel) {
                
            } label: {
                Text("Ok")
            }
        }
        .fullScreenCover(isPresented: self.$showExercisesDBList) {
            ExercisesDBList(exerciseName: self.$exerciseName)
        }
    }
}
