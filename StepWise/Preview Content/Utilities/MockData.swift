//
//  MockData.swift
//  StepWise
//
//  Created by Tarun Sharma on 20/03/26.
//

import Foundation

struct MockData {
    static var steps: [HealthMetrics] {
        var array: [HealthMetrics] = []
        
        for i in 0..<28 {
            let metric = HealthMetrics(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!,
                                       value: .random(in: 4_000...15_000))
            array.append(metric)
        }
        return array
    }
    
    static var weights: [HealthMetrics] {
        var array: [HealthMetrics] = []
        
        for i in 0..<28 {
            let metric = HealthMetrics(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!,
                                       value: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
            array.append(metric)
        }
        return array
    }
    
    static var weightDiffs: [DateValueChartData] {
        var array: [DateValueChartData] = []
        
        for i in 0..<7 {
            let diff = DateValueChartData(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!,
                                       value: .random(in: -3...3))
            array.append(diff)
        }
        return array
    }


}
