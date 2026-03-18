//
//  HealthMetrics.swift
//  StepWise
//
//  Created by Tarun Sharma on 18/03/26.
//

import Foundation

struct HealthMetrics : Identifiable {
    let id = UUID()
    let date : Date
    let value : Double
    
    static var mockData: [HealthMetrics] {
        var array: [HealthMetrics] = []
        
        for i in 0..<28 {
            let metric = HealthMetrics(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!,
                                       value: .random(in: 4_000...15_000))
            array.append(metric)
        }
        return array
    }
}
