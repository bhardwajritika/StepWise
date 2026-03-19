//
//  WeightLineChart.swift
//  StepWise
//
//  Created by Tarun Sharma on 20/03/26.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    
    var selectedStat : HealthMetricsContext
    var chartData : [HealthMetrics]
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Weight", systemImage: "figure")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo)
                        
                        Text("Avg: 70 kg")
                            .font(.caption)
                        
                    }
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                    
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                ForEach(chartData) { weight in
                    AreaMark(
                        x: .value("Day", weight.date, unit: .day),
                        y: .value("Weight", weight.value)
                    )
                    .foregroundStyle(Gradient(colors: [.blue.opacity(0.5), .clear]))

                    LineMark(
                        x: .value("Day", weight.date, unit: .day),
                        y: .value("Weight", weight.value)
                    )
                }
            }
            .frame(height: 150)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    WeightLineChart(selectedStat: .weight, chartData: MockData.weights)
}
