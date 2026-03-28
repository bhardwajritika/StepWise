//
//  ChartHelper.swift
//  StepWise
//
//  Created by Tarun Sharma on 24/03/26.
//

import Foundation
import Algorithms

struct ChartHelper {
    /// convert the HealthMetric data to DateValueChartData  model
    /// - Parameter data: HealthMetric data
    /// - Returns: DateValueChartData
    static func convert(data: [HealthMetrics]) -> [DateValueChartData] {
        data.map {
            .init(date: $0.date, value: $0.value)
        }
    }
    
    /// calculate the average of the array
    /// - Parameter data: Array of ``DateValueChartData``
    /// - Returns: Double value
    static func averageValue(for data: [DateValueChartData]) -> Double {
        guard !data.isEmpty else { return 0 }
        let totalSteps = data.reduce(0) { $0 + $1.value }
        return totalSteps / Double(data.count)
    }
    
    
    static func parseSelectedData(from data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        return data.first {
            Calendar.current.isDate(selectedDate, inSameDayAs: $0.date)
        }
    }
    
    /// calculate the average weekday count
    /// - Parameter metric: array of ``HealthMetrics``
    /// - Returns: weekdayChartdata
    static func avgWeekdayCount(for metric: [HealthMetrics]) -> [DateValueChartData] {
        let sortedByWeekday = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt}
        let weekdayArray = sortedByWeekday.chunked{ $0.date.weekdayInt == $1.date.weekdayInt }
        var weekdayChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgSteps = total / Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: avgSteps))
        }
        
        return weekdayChartData
    }
    
    /// Calculate the average daily weight difference
    /// - Parameter weights: array of ``HealthMetrics``
    /// - Returns: array of  weekdayChart Data
    static func avgDailyWeightDiff(for weights: [HealthMetrics]) -> [DateValueChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        
        guard weights.count > 1 else { return [] }
        for i in 1..<weights.count{
            let date = weights[i].date
            let diff = weights[i].value - weights[i-1].value
            diffValues.append((date: date, value: diff))
        }
        let sortedByWeekday = diffValues.sorted { $0.date.weekdayInt < $1.date.weekdayInt}
        let weekdayArray = sortedByWeekday.chunked{ $0.date.weekdayInt == $1.date.weekdayInt }
        var weekdayChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgWeightDiff = total / Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: avgWeightDiff))
        }
        return weekdayChartData
        
    }
}
