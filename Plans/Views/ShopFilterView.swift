//
//  ShopView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 19/02/22.
//

import SwiftUI

struct ShopFilterView: View {
    
    @Binding var showFilterView: Bool
    @Binding var workoutDays: Double
    @Binding var likes: Double
    @Binding var downloads: Double
    @Binding var levelSelected: Int
    @Binding var coachEmail: String
    let levelsArray = ["Beginner","Intermediate","Advanced"]
    
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(uiColor: UIColor.secondarySystemFill))
                    .overlay(
                        VStack(spacing:20) {
                            
                            TextField("Coach email", text: self.$coachEmail)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                            
                            Picker("Level", selection: self.$levelSelected) {
                                ForEach(self.levelsArray.indices, id: \.self) { index in
                                    Text(self.levelsArray[index]).tag(index)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            Stepper("Workout Days \(self.workoutDays, specifier: "%.0f")", value: self.$workoutDays, in: 2 ... 7)
                            
                            Stepper("Likes \(self.likes, specifier: "%.0f")", value: self.$likes, in: 0 ... 100000, step: 1000)
                            
                            Stepper("Downloads \(self.downloads, specifier: "%.0f")", value: self.$downloads, in: 0 ... 100000, step: 1000)
                            
                            Spacer()
                            
                            Button {
                                self.showFilterView.toggle()
                            } label: {
                                Image(systemName: "xmark.circle")
                            }
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 30, height: 400)
                        
                    )
                    .frame(width: UIScreen.main.bounds.width - 30, height: 450)
                    .padding()
                
                Spacer()
            }
        }
    }
}
