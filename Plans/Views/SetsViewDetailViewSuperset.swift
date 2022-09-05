//
//  SetsViewDetailViewSuperset.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 09/02/22.
//

import SwiftUI

struct SetsViewDetailViewSuperset: View {
    
    let indexNum: Int
    @ObservedObject var exerciseSupersetModel: ExerciseSupersetModel
    
    var body: some View {
        VStack {
            HStack {
                SetItemView(text: self.exerciseSupersetModel.sets[self.indexNum].reps)

                SetItemView(text: self.exerciseSupersetModel.sets[self.indexNum].latestReps)
                
                SetItemTextFieldView(placeholder: "New", textValue: self.$exerciseSupersetModel.sets[self.indexNum].newReps)
                
                SetItemTextFieldView(placeholder: "\(self.exerciseSupersetModel.sets[self.indexNum].weight)", textValue: self.$exerciseSupersetModel.sets[self.indexNum].weight)
            }
        }
        .font(.system(size: 12))
    }
}
