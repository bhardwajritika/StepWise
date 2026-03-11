//
//  HealthKitManager.swift
//  StepWise
//
//  Created by Tarun Sharma on 11/03/26.
//

import Foundation
import SwiftUI
import HealthKit
import Observation

@Observable class HealthKitManager {
    
    let store = HKHealthStore()
    
    let type: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}
