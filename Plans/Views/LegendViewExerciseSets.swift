//
//  LegendViewExerciseSets.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI

struct LegendViewExerciseSets: View {
    
    let rowHeaders = ["Reps","Last","New","Weight","Rest"]
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(self.rowHeaders, id:\.self) { rowHeader in
                SetItemView(text: rowHeader)
                    .font(.system(size: 10))
            }
        }
    }
}
