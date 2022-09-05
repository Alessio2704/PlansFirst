//
//  ExerciseNotesView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 03/05/22.
//

import SwiftUI

struct ExerciseNotesView: View {
    
    let exercise: Exercise
    @State var focus = false
    @Binding var exerciseNotes: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Exercise Notes")
                            .font(.footnote)
                        Spacer()
                        Button {
                            self.focus = false
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.body)
                                .padding(5)
                                .overlay(Rectangle().strokeBorder().foregroundColor(.secondary))
                            
                        }
                        
                    }
                    CustomTextEditor(placeholder: "Take notes on how to execute the exercise, machines settings, form adjustments...", text: self.$exerciseNotes, isFocused: self.$focus)
                        .onTapGesture {
                            self.focus = true
                        }
                }
            }
            
            
            Button {
                CoreDataManager().updateExerciseNotes(id: self.exercise.id ?? UUID(), notes: self.exerciseNotes)
                dismiss()
            } label: {
                Text("Save")
                    .padding()
                    .background(Color(uiColor: UIColor.secondarySystemFill))
                    .cornerRadius(20)
                    .foregroundColor(.primary)
            }
        }
        .padding()
    }
}

