//
//  LegendViewEditExercise.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 25/02/22.
//

import SwiftUI

struct LegendViewEditExerciseSets: View {
    
    let rowHeaders = ["KGs","Reps","Rest"]
    
    var body: some View {
        HStack (spacing: 5) {
            ForEach(self.rowHeaders, id:\.self) { rowHeader in
                SetItemViewEdit(text: rowHeader)
            }
        }
        .font(.footnote)
    }
}
