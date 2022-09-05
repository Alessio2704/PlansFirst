//
//  PlanCloudCardView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 04/02/22.
//

import SwiftUI

struct PlanCloudCardView: View {
    
    var plan: PlanApi
    
    var body: some View {
        RoundedRectangle(cornerRadius: 40)
            .fill(Color(uiColor: .secondarySystemFill))
            .frame(width: 350, height: 150)
            .overlay(
                VStack(alignment:.center, spacing: 10) {
                    Text("\(self.plan.planName)")
                        .font(.title2)
                    
                    Spacer()
                    
                    HStack {
                        ForEach(0 ..< getWorkoutDays(), id: \.self) { _ in
                            Image(systemName: "calendar")
                                .font(.title2)
                        }
                    }
                    
                    Spacer()
                    
                    Text("\(self.plan.level)")
                        .font(.title2)
                        .foregroundColor(self.plan.level == "Beginner" ? .green : self.plan.level == "Intermediate" ? .orange : .red)
                }
                    .padding(20)
                    .foregroundColor(.primary)

            )
            
    }
    
}

extension PlanCloudCardView {
    
    func getWorkoutDays() -> Int {
        
        var daysSet: Set<String> = Set()
        
        for exercise in self.plan.exercises {
            daysSet.insert(exercise.day)
        }
        for supersets in self.plan.supersets {
            daysSet.insert(supersets.day)
        }
        return daysSet.count
    }
}
