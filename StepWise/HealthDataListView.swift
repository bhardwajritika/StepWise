//
//  HealthDataListView.swift
//  StepWise
//
//  Created by Tarun Sharma on 10/03/26.
//

import SwiftUI

struct HealthDataListView: View {
    var metric : HealthMetricsContext
    
    var body: some View {
        List(0..<28){ i in
            HStack {
                Text(Date(), format: .dateTime.month().day().year())
                Spacer()
                Text(1000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            }
            
        }
        .navigationTitle(metric.title)
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .steps)
    }
   
}
