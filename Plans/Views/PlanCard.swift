//
//  PlanCard.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct PlanCard: View {
    
    var plan: Plan
    @EnvironmentObject var currentPlanManager: CurrentPlanManager
    
    var body: some View {
        RoundedRectangle(cornerRadius: 40)
            .fill(Color(uiColor: .secondarySystemFill))
            .frame(width: 350, height: 150)
            .overlay(RoundedRectangle(cornerRadius: 40).strokeBorder(lineWidth: 5).foregroundColor(self.currentPlanManager.isCurrentPlan.contains(self.plan) ? .blue : Color(uiColor: .secondarySystemFill)))
            .overlay(
                VStack(alignment:.center, spacing: 10) {
                    Text("\(plan.name ?? "")")
                        .font(.title2)
                    
                    Spacer()
                    
                    HStack {
                        ForEach(0 ..< getWorkoutDays(plan: self.plan), id: \.self) { _ in
                            Image(systemName: "calendar")
                                .font(.title2)
                        }
                    }
                    
                    Spacer()
                    
                    Text("\(self.plan.level ?? "")")
                        .font(.title2)
                        .foregroundColor(self.plan.level == "Beginner" ? .green : self.plan.level == "Intermediate" ? .orange : .red)
                }
                    .padding(20)
                    .foregroundColor(.primary)

            )
            
    }
}

extension PlanCard {
    
    func getWorkoutDays(plan: Plan) -> Int {
        
        guard let planDB = CoreDataManager.shared.getPlan(id: plan.id ?? UUID()) else { return 0 }
        
        
        if (planDB.exercises?.allObjects == nil) {
            return 0
        } else {
            let exercisesArray = plan.exercises?.allObjects as! [Exercise]
            var daysSet: Set<String> = Set()
            
            for exercise in exercisesArray {
                daysSet.insert(exercise.day ?? "")
            }
            return daysSet.count
        }
    }
}
