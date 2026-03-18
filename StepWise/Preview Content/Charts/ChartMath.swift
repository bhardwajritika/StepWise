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
        
//        for metric in sortedByWeekday {
//            print("Day: \(metric.date.weekdayInt), Value: \(metric.value)")
//        }
//        print("---------------------------")
//        for day in weekdayChartData {
//            print("Day: \(day.date.weekdayInt), Value: \(day.value)")
//        }
        
        return weekdayChartData
    }
}
