//
//  SWError.swift
//  StepWise
//
//  Created by Tarun Sharma on 24/03/26.
//

import Foundation

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
