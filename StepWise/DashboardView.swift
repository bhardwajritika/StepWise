//
//  ContentView.swift
//  StepWise
//
//  Created by Tarun Sharma on 06/03/26.
//

import SwiftUI

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
                    VStack {
                        NavigationLink(value: selectedStat) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("Steps", systemImage: "figure.walk")
                                        .font(.title3.bold())
                                        .foregroundStyle(.pink)
                                    
                                    Text("Avg: 10k steps")
                                        .font(.caption)
                                    
                                }
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 150)
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                    
                    
                    VStack (alignment: .leading){
                            VStack(alignment: .leading) {
                                Label("Average", systemImage: "calendar")
                                    .font(.title3.bold())
                                    .foregroundStyle(.pink)
                                
                                Text("Last 28 days")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                            }
                            .padding(.bottom, 12)
                            RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
            }
            .padding()
            .task {
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
