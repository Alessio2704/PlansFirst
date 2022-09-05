//
//  SetView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct AddExerciseSetView: View {
    
    let edit: Bool
    let index: Int
    let dimension = UIScreen.main.bounds.width - 50
    @ObservedObject var exerciseModel: ExerciseModel
    @ObservedObject var setModelView: SetModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                VStack {
                    TextField("KGs", text: self.$setModelView.weight)
                        .keyboardType(.numbersAndPunctuation)
                }
                .frame(width: dimension / 8 )
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
                VStack {
                    TextField("Reps", text: self.$setModelView.reps)
                        .keyboardType(.numbersAndPunctuation)
                }
                .frame(width: dimension / 8 )
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
                VStack {
                    TextField("Rest", text: self.$setModelView.restTime)
                        .keyboardType(.numbersAndPunctuation)
                }
                .frame(width: dimension / 8)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
                VStack {
                    Button {
                        let copiedSet = SetModel()
                        copiedSet.reps = self.setModelView.reps
                        copiedSet.weight = self.setModelView.weight
                        copiedSet.restTime = self.setModelView.restTime
                        copiedSet.latestReps = self.setModelView.latestReps
                        copiedSet.number = self.setModelView.number + 1
                        self.exerciseModel.sets.append(copiedSet)
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                }
                .frame(width: dimension / 30 )
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
                VStack {
                    Button {
                        self.exerciseModel.sets.remove(at: self.index)
                        
                        if (self.edit) {
                            CoreDataManager().deleteSet(setID: self.setModelView.id)
                        }
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .frame(width: dimension / 30 )
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
            }
            .font(.footnote)
        }
    }
}
