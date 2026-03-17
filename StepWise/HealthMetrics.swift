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
}
