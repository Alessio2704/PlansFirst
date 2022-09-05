//
//  AddPlanView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct AddPlanView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var planName = ""
    @State private var planNotes = ""
    @State private var showEmptyNameAlert = false
    @State var focus: Bool = false
    @State var levelSelected = 0
    let levelsArray = ["Beginner","Intermediate","Advanced"]
    
    var body: some View {
        
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing:30) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Plan Name")
                            .font(.footnote)
                        TextField("Name", text: self.$planName)
                        .textFieldStyle(.roundedBorder)
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Plan Intensity Level")
                            .font(.footnote)
                        
                        Picker("Level", selection: self.$levelSelected) {
                            ForEach(self.levelsArray.indices, id: \.self) { index in
                                Text(self.levelsArray[index]).tag(index)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
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
                        CustomTextEditor(placeholder: "Write something to let others know hot to execute this plan", text: self.$planNotes, isFocused: self.$focus)
                            .onTapGesture {
                                self.focus = true
                            }
                    }
                    
                    Text("Add")
                        .frame(width:40, height: 40)
                        .padding(10)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .onTapGesture {
                            
                            if(self.planName != "") {
                                CoreDataManager().createPlan(planName: self.planName, planNotes: self.planNotes, level: self.levelsArray[self.levelSelected])
                                self.planName = ""
                                dismiss()
                            } else {
                                self.showEmptyNameAlert.toggle()
                            }
                        }
                }
                .padding(.horizontal, 10)
                .onAppear {
                    UITextField.appearance().backgroundColor = UIColor.secondarySystemFill
                }
                .onDisappear {
                    UITextField.appearance().backgroundColor = nil
                }
                .alert(Text("Please enter a name"), isPresented: self.$showEmptyNameAlert) {
                    Button(role: ButtonRole.cancel) {
                        
                    } label: {
                        Text("Ok")
                    }

                }
            .navigationTitle(Text("Create Plan"))
            .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
