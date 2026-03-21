//
//  ChartMath.swift
//  StepWise
//
//  Created by Tarun Sharma on 18/03/26.
//

import Foundation
import Algorithms

struct ChartMath {
    
    
    static func avgWeekdayCount(for metric: [HealthMetrics]) -> [WeekdayChartData] {
        let sortedByWeekday = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
        let weekdayArray = sortedByWeekday.chunked{ $0.date.weekdayInt == $1.date.weekdayInt }
        var weekdayChartData: [WeekdayChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgSteps = total / Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: avgSteps))
        }
        
        return weekdayChartData
    }
    
    static func avgDailyWeightDiff(for weights: [HealthMetrics]) -> [WeekdayChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        
        for i in 1..<weights.count{
            let date = weights[i].date
            let diff = weights[i].value - weights[i-1].value
            diffValues.append((date: date, value: diff))
        }
        let sortedByWeekday = diffValues.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
        let weekdayArray = sortedByWeekday.chunked{ $0.date.weekdayInt == $1.date.weekdayInt }
        var weekdayChartData: [WeekdayChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgWeightDiff = total / Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: avgWeightDiff))
        }
        for value in diffValues {
            print("\(value.date) -- \(value.value)")
        }
        
        for value in weekdayChartData {
            print("\(value.date) -- \(value.value)")
        }

        
        return weekdayChartData
                
    }
}
