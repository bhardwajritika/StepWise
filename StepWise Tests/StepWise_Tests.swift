//
//  StepWise_Tests.swift
//  StepWise Tests
//
//  Created by Tarun Sharma on 27/03/26.
//

import Foundation
import Testing
@testable import StepWise

struct StepWise_Tests {

    @Test func arrayAverage() {
        let array : [Double] = [2.0, 3.1, 0.45, 1.84]
        #expect(array.average == 1.8475)
        
    }
}

@Suite("ChartHelper Tests") struct ChartHelperTests {
    
    var metrics: [HealthMetrics] = [
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 14))!, value: 1000),
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 15))!, value: 500),
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 16))!, value: 250),
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 21))!, value: 750)
    ]
    
    @Test func averageWeekdayCount() {
        let averageWeekdayCount = ChartHelper.avgWeekdayCount(for: metrics)
        #expect(averageWeekdayCount.count == 3)
        #expect(averageWeekdayCount[0].value == 875)
        #expect(averageWeekdayCount[1].value == 500)
        #expect(averageWeekdayCount[2].date.weekdayTitle == "Wednesday")
    }
}
