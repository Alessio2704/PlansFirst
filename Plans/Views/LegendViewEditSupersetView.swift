//
//  LegendViewEditSupersetView.swift
//  Plans
//
//  Created by Alessio Marcuzzi on 03/05/22.
//

import SwiftUI

struct LegendViewEditSupersetView: View {
    let rowHeaders = ["KGs","Reps"]
    
    var body: some View {
        HStack (spacing: 5) {
            ForEach(self.rowHeaders, id:\.self) { rowHeader in
                SetItemViewEdit(text: rowHeader)
            }
        }
        .font(.footnote)
    }
}
