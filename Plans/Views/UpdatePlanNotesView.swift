//
//  UpdatePlanNotesView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 22/02/22.
//

import SwiftUI

struct UpdatePlanNotesView: View {
    
    let plan: Plan
    @State var focus = false
    @Binding var planNotes: String
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Plan Method Description")
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
                    CustomTextEditor(placeholder: "Write something to let others know how to execute this plan", text: self.$planNotes, isFocused: self.$focus)
                        .onTapGesture {
                            self.focus = true
                        }
                }
            }
            
            
            Button {
                CoreDataManager().updatePlanNotes(plan: self.plan, notes: self.planNotes)
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
