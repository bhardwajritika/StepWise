//
//  Array+Ext.swift
//  StepWise
//
//  Created by Tarun Sharma on 25/03/26.
//

import Foundation

extension Array where Element == Double {
    var average : Double {
        guard !self.isEmpty else { return 0 }
        let total = self.reduce(0, +)
        return total / Double(self.count)
    }
}
