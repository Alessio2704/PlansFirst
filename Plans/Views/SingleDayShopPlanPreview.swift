//
//  SingleDayShopPlanPreview.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 09/05/22.
//

import SwiftUI

struct SingleDayShopPlanPreview: View {
    
    let daysDict = [
        "Sun": "Sunday",
        "Mon": "Monday",
        "Tue": "Tuesday",
        "Wed": "Wednesday",
        "Thu": "Thursday",
        "Fri": "Friday",
        "Sat": "Saturday"
    ]
    
    let downloadedPlan: PlanApi
    let day: String
    @State private var exericesArray: [String] = []
    
    var body: some View {

        VStack(spacing:10) {
            
            Text(self.daysDict[self.day] ?? "")
                .font(.title2)
                .foregroundColor(.blue)
                .padding(.top)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing:10) {
                    ForEach(self.exericesArray, id: \.self) { ex in
                        Text(ex)
                        Divider()
                    }
                }
            }
            .padding()
        }
        .font(.body)
        .frame(width: 350, height: 400)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(30)
        .shadow(color: .gray, radius: 10)
        .padding()
        .onAppear {
            let exercisesCloud = downloadedPlan.exercises.filter({ $0.day == self.day })
            let supersetsCloud = downloadedPlan.supersets.filter({ $0.day == self.day })
            
            for exerciseCloud in exercisesCloud.sorted(by: { $0.rowOrder < $1.rowOrder }) {
                self.exericesArray.append(exerciseCloud.name)
            }
            
            for _ in supersetsCloud.sorted(by: { $0.exerciseOrder < $1.exerciseOrder }) {
                self.exericesArray.append("Superset")
            }
        }
    }
}
