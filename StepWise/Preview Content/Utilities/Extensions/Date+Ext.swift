//
//  Date+Ext.swift
//  StepWise
//
//  Created by Tarun Sharma on 18/03/26.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var weekdayTitle : String {
        switch weekdayInt {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default:
            return ""
        }
    }
}
