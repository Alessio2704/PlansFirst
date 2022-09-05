//
//  PublishedPlanShopInfoCard.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 20/02/22.
//

import SwiftUI

struct PublishedPlanShopInfoCard: View {
    
    let plan: PublicPlanInfoApi
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 40)
            .fill(Color(uiColor: .secondarySystemFill))
            .frame(width: 350, height: 200)
            .overlay(
                VStack(alignment:.center, spacing: 15) {

                        Text("\(plan.planName)")
                            .font(.title2)
                        
                        HStack {
                            ForEach(0 ..< self.plan.workoutDays, id: \.self) { _ in
                                Image(systemName: "calendar")
                                    .font(.title2)
                            }
                        }
                    
                    Text("\(self.plan.level)")
                        .font(.title2)
                        .foregroundColor(self.plan.level == "Beginner" ? .green : self.plan.level == "Intermediate" ? .orange : .red)
                    
                    Spacer()
                    
                    HStack {
                        Text(self.plan.createdBy)
                            .font(.footnote)
                        Spacer()
                        HStack {
                            Text(self.plan.likes > 1000 ? "\(self.plan.likes / 1000)" : "\(self.plan.likes)")
                            Image(systemName: "heart.circle")
                        }
                        HStack {
                            Text(self.plan.downloads > 1000 ? "\(self.plan.downloads / 1000)": "\(self.plan.downloads)")
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                    .font(.footnote)
                    
                }
                    .padding(20)
                    .foregroundColor(.primary)

            )
    }
}


