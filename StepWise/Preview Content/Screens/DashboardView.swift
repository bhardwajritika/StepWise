//
//  ContentView.swift
//  StepWise
//
//  Created by Tarun Sharma on 06/03/26.
//

import SwiftUI
import Charts

enum HealthMetricsContext: CaseIterable, Identifiable {
    case steps, weight
    var id : Self { self }
    
    var title: String {
        switch self {
        case .steps:
            return "Steps"
        case .weight:
            return "Weight"
        }
    }
}

struct DashboardView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming: Bool = false
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat : HealthMetricsContext = .steps
    var isSteps: Bool {
        selectedStat == .steps
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Selected Stat", selection: $selectedStat){
                        ForEach(HealthMetricsContext.allCases) { metric in
                            Text(metric.title)
                            
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch selectedStat {
                        case .steps:
                        StepBarChart(selectedStat: selectedStat, chartData: hkManager.stepData)
                        StepPieChart(chartData: ChartMath.avgWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(selectedStat: selectedStat, chartData: hkManager.weightData)
                        
                        
                    
                    }
                    
                    
                }
            }
            .padding()
            .task {
                
                await hkManager.fetchStepCount()
                await hkManager.fetchWeights()
                ChartMath.avgWeekdayCount(for: hkManager.stepData)
                isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
            }
            .navigationTitle(Text("Dashboard"))
            .navigationDestination(for: HealthMetricsContext.self) { metric in
                HealthDataListView(metric: metric)
                
            }
            .sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                // fetch health data
            } , content: {
                HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
            })

        }
        .tint(isSteps ? .pink : .indigo)
    }
    
    
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
