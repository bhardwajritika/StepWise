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

enum SWError: LocalizedError {
    case authNotDetermined
    case sharingDenied(for: String)
    case noData
    case unableToCompleteRequest
    case invalidValue
    
    var errorDescription: String? {
        switch self {
        case .authNotDetermined:
            "Need access to Health Data"
        case .sharingDenied(_):
            "No Write Access"
        case .noData:
            "No Data"
        case .unableToCompleteRequest:
            "Unable to Complete Request"
        case .invalidValue:
            "Invalid Value"
        }
    }
    
    var failureReason: String {
        switch self {
        case .authNotDetermined:
            "You have not given access to your Health Data. Please go to Settings > Health > Data Access & Devices"
        case .sharingDenied(let quantityType):
            "You have denied to upload your \(quantityType) data. \n\n You can change this in Settings > Health > Data Access & Devices"
        case .noData:
            "There is no data for this Health Statistics"
        case .unableToCompleteRequest:
            "We are unable to complete your request at this time.\n\n Please try again later or contact support"
        case .invalidValue:
            "Must be a numeric value with maximum of one decimal place"
        }
    }
}

@Observable class HealthKitManager {
    
    let store = HKHealthStore()
    
    let type: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    
    var stepData : [HealthMetrics] = []
    var weightData : [HealthMetrics] = []
    var weightDiffData : [HealthMetrics] = []
    
    func fetchStepCount() async throws {
        
        guard store.authorizationStatus(for: HKQuantityType(.stepCount)) != .notDetermined else {
            throw SWError.authNotDetermined
        }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: .init(.stepCount), predicate: queryPredicate)
        let stepQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                              options: .cumulativeSum,
                                                              anchorDate: endDate,
                                                              intervalComponents: .init(day: 1))
        
        do {
            let stepCounts = try await stepQuery.result(for: store)
            stepData = stepCounts.statistics().map {
                .init(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        } catch HKError.errorNoData{
            throw SWError.noData
        } catch {
            throw SWError.unableToCompleteRequest
        }
                    
    }
    
    func fetchWeights() async throws {
        guard store.authorizationStatus(for: HKQuantityType(.bodyMass)) != .notDetermined else {
            throw SWError.authNotDetermined
        }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let samplePredicate = HKSamplePredicate.quantitySample(type: .init(.bodyMass), predicate: queryPredicate)
        let weightQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                              options: .mostRecent,
                                                              anchorDate: endDate,
                                                              intervalComponents: .init(day: 1))
        
        do {
            let weights = try await weightQuery.result(for: store)
            weightData = weights.statistics().map {
                .init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        } catch HKError.errorNoData{
            throw SWError.noData
        } catch {
            throw SWError.unableToCompleteRequest
        }
        
    }
    
    func fetchWeightForDifferentials() async throws {
        guard store.authorizationStatus(for: HKQuantityType(.bodyMass)) != .notDetermined else {
            throw SWError.authNotDetermined
        }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -29, to: endDate)
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let samplePredicate = HKSamplePredicate.quantitySample(type: .init(.bodyMass), predicate: queryPredicate)
        let weightQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                                options: .mostRecent,
                                                                anchorDate: endDate,
                                                                intervalComponents: .init(day: 1))
        
        do {
            let weights = try await weightQuery.result(for: store)
            weightDiffData = weights.statistics().map {
                .init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        } catch HKError.errorNoData{
            throw SWError.noData
        } catch {
            throw SWError.unableToCompleteRequest
        }
        
    }
    
    func addStepData(for date: Date, value: Double) async throws {
        let status = store.authorizationStatus(for: HKQuantityType(.stepCount))
        switch status {
        case .notDetermined :
            throw SWError.authNotDetermined
        case .sharingDenied:
            throw SWError.sharingDenied(for: "step count")
        case .sharingAuthorized:
            break
        @unknown default:
            break
        }
        let stepQuantity = HKQuantity(unit: .count(), doubleValue: value)
        let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: date, end: date)
        do {
            try await store.save(stepSample)
        } catch {
            throw SWError.unableToCompleteRequest
        }
    }
    
    func addWeightData(for date: Date, value: Double) async throws {
        let status = store.authorizationStatus(for: HKQuantityType(.bodyMass))
        switch status {
        case .notDetermined :
            throw SWError.authNotDetermined
        case .sharingDenied:
            throw SWError.sharingDenied(for: "Weight data")
        case .sharingAuthorized:
            break
        @unknown default:
            break
        }

        let weightQuantity = HKQuantity(unit: .pound(), doubleValue: value)
        let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: date, end: date)
        do {
            try await store.save(weightSample)
        } catch {
            throw SWError.unableToCompleteRequest
        }
    }

    
//    func addSimulatorData() async {
//        var mockSamples: [HKQuantitySample] = []
//        
//        for i in 0..<28 {
//            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
//            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
//            
//            let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
//            let endDate = Calendar.current.date(byAdding: .second, value: 1, to: startDate)!
//            
//            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
//            let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: startDate, end: endDate)
//            
//            mockSamples.append(stepSample)
//            mockSamples.append(weightSample)
//        }
//        
//        try! await store.save(mockSamples)
//        print("Dummy data sent up")
//    }
}
