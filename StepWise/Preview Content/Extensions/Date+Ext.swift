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
}
