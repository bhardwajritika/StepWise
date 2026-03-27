//
//  StepWiseApp.swift
//  StepWise
//
//  Created by Tarun Sharma on 06/03/26.
//

import SwiftUI

@main
struct StepWiseApp: App {
    let hkData = HealthKitData()
    let hkManager = HealthKitManager()
    
    var body: some Scene {
       
        WindowGroup {
            DashboardView()
                .environment(hkData)
                .environment(hkManager)
        }
    }
}
