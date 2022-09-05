//
//  LegendViewSupersetView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 09/02/22.
//

import SwiftUI

struct LegendViewSupersetView: View {
    
    let rowHeaders = ["Reps","Last","New","Weight"]
    
    var body: some View {
        HStack {
            ForEach(self.rowHeaders, id:\.self) { rowHeader in
                SetItemView(text: rowHeader)
                    .font(.system(size: 10))
            }
        }
        .font(.footnote)
    }
}
