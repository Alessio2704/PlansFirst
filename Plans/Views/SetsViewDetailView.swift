//
//  SetsViewDetailView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct SetsViewDetailView: View {
    
    @Environment(\.scenePhase) var scene
    @ObservedObject var exerciseModel: ExerciseModel
    let indexNum: Int
    let dimension = UIScreen.main.bounds.width - 50
    let widthIconDivider = 7.0
    let paddingIcon = 9.0
    @State private var showTimerView = false
    @State var start:Bool = false
    @State var to:CGFloat = 1
    @State var count:Double = 0.0
    @State var exitTime = Date()
    @State var diff = 0.0
    
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                SetItemView(text: self.exerciseModel.sets[self.indexNum].reps)

                SetItemView(text: self.exerciseModel.sets[self.indexNum].latestReps)
                
                SetItemTextFieldView(placeholder: "New", textValue: self.$exerciseModel.sets[self.indexNum].newReps)
                
                SetItemTextFieldView(placeholder: "\(self.exerciseModel.sets[self.indexNum].weight)", textValue: self.$exerciseModel.sets[self.indexNum].weight)
                
                SetItemView(text: self.exerciseModel.sets[self.indexNum].restTime)
                    .onTapGesture {
                        self.showTimerView.toggle()
                    }
            }
        }
        .font(.system(size: 12))
        .onAppear(perform: {
            self.count = Double(self.exerciseModel.sets[self.indexNum].restTime) ?? 0.0
        })
        .sheet(isPresented: self.$showTimerView) {
            TimerView(exerciseName: self.exerciseModel.name, time: Double(self.exerciseModel.sets[self.indexNum].restTime) ?? 0.0, start: self.$start, to: self.$to, count: self.$count, exitTime: self.$exitTime, diff: self.$diff )
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
                                    self.to = CGFloat(self.count/(Double(self.exerciseModel.sets[self.indexNum].restTime) ?? 0.0))
                                }
                            } else {
                                withAnimation {
                                    self.count = Double(self.exerciseModel.sets[self.indexNum].restTime) ?? 0.0
                                    self.to = 1
                                    self.start = false
                                }
                            }
                        }
                    }
                }
        }
    }
}

