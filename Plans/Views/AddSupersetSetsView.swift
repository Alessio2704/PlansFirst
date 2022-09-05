//
//  AddSupersetSetsView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 09/02/22.
//

import SwiftUI

struct AddSupersetSetsView: View {
    
    let edit: Bool
    let index: Int
    let dimension = UIScreen.main.bounds.width - 50
    @ObservedObject var exerciseSupersetModel: ExerciseSupersetModel
    @ObservedObject var setModelSupersetView: SetModelSuperset
    
    var body: some View {
        HStack(spacing: 5) {
            VStack {
                TextField("KGs", text: self.$setModelSupersetView.weight)
                    .keyboardType(.numbersAndPunctuation)
            }
            .frame(width: dimension / 8 )
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
            VStack {
                TextField("Reps", text: self.$setModelSupersetView.reps)
                    .keyboardType(.numbersAndPunctuation)
            }
            .frame(width: dimension / 8 )
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
            VStack {
                Button {
                    let copiedSet = SetModelSuperset()
                    copiedSet.reps = self.setModelSupersetView.reps
                    copiedSet.weight = self.setModelSupersetView.weight
                    copiedSet.latestReps = self.setModelSupersetView.latestReps
                    copiedSet.number = self.setModelSupersetView.number + 1
                    self.exerciseSupersetModel.sets.append(copiedSet)
                } label: {
                    Image(systemName: "doc.on.doc")
                }
            }
            .frame(width: dimension / 30 )
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder())
            VStack {
                Button {
                    self.exerciseSupersetModel.sets.remove(at: self.index)
                    
                    if (self.edit) {
                        CoreDataManager.shared.deleteSet(setID: self.setModelSupersetView.id)
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

