//
//  ChartAnnotationView.swift
//  StepWise
//
//  Created by Tarun Sharma on 24/03/26.
//

import SwiftUI

struct ChartAnnotationView: View {
    
    let data : DateValueChartData
    let context: HealthMetricsContext
    
    
    var body: some View {
        VStack (alignment: .leading){
            Text(data.date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(data.value, format: .number.precision(.fractionLength(context == .steps ? 0 : 1)))
                .fontWeight(.heavy)
                .foregroundStyle(context == .steps ? Color.pink : Color.indigo)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    ChartAnnotationView(data: .init(date: .now, value: 1000), context: .steps)
}
