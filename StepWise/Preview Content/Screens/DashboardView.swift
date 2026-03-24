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
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat : HealthMetricsContext = .steps
    @State private var isShowingAlert = false
    @State private var fetchError : SWError = .noData
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
                        StepBarChart( chartData: ChartHelper.convert(data: hkManager.stepData))
                        StepPieChart(chartData: ChartMath.avgWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart( chartData: ChartHelper.convert(data: hkManager.weightData))
                        WeightDiffBarChart(chartData: ChartMath.avgDailyWeightDiff(for: hkManager.weightDiffData))
                    
                    }
                    
                    
                }
            }
            .padding()
            .task {
                do {
                    try await hkManager.fetchStepCount()
                    try await hkManager.fetchWeights()
                    try await hkManager.fetchWeightForDifferentials()
                    
                } catch SWError.authNotDetermined{
                    isShowingPermissionPrimingSheet = true
                } catch SWError.noData {
                    fetchError = .noData
                    isShowingAlert = true
                } catch {
                    fetchError = .unableToCompleteRequest
                    isShowingAlert = true
                }
                
            }
            .navigationTitle(Text("Dashboard"))
            .navigationDestination(for: HealthMetricsContext.self) { metric in
                HealthDataListView( metric: metric)
                
            }
            .sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                // fetch health data
            } , content: {
                HealthKitPermissionPrimingView()
            })
            .alert(isPresented: $isShowingAlert,
                   error: fetchError) { fetchError in
                //Action
            } message: { fetchError in
                Text(fetchError.failureReason)
            }


        }
        .tint(isSteps ? .pink : .indigo)
    }
    
    
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
