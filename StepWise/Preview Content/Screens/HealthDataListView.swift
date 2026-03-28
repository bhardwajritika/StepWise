//
//  HealthDataListView.swift
//  StepWise
//
//  Created by Tarun Sharma on 10/03/26.
//

import SwiftUI

struct HealthDataListView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @Environment(HealthKitData.self) private var hkData
    @Namespace var zoomTransition
    @State private var isShowingAddData = false
    @State private var addDataDate : Date = .now
    @State private var valueToAdd : String = ""
    @State private var isShowingAlert = false
    @State private var writeError : SWError = .noData
    
    var metric : HealthMetricsContext
    
    var listData: [HealthMetrics] {
        metric == .steps ? hkData.stepData : hkData.weightData
    }
    
    var metricColor: Color {
        metric == .steps ? .pink : .indigo
    }
    
    
    var body: some View {
        List(listData.reversed()){ data in
            LabeledContent {
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            } label: {
                Text(data.date, format: .dateTime.month().day().year())
                    .accessibilityLabel(data.date.accessibilityDate)
            }
            .listRowBackground(Color(.secondarySystemBackground).opacity(0.35))
            .accessibilityElement(children:.combine )

        }
        .navigationTitle(metric.title)
        .scrollContentBackground(.hidden)
        .background(LinearGradient(colors: [metricColor.opacity(0.25), .clear],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
        .sheet(isPresented: $isShowingAddData) {
            if #available(iOS 26, *) {
                addDataView
                    .presentationDetents([.fraction(0.4)])
                    .scrollContentBackground(.hidden)
                    .navigationTransition(.zoom(sourceID: "adddata", in: zoomTransition))
            } else {
                addDataView
                    .presentationDetents([.fraction(0.4)])
            }
        }
        .overlay {
            if listData.isEmpty {
                ContentUnavailableView("No \(metric.title) to Display", systemImage: metric == .steps ? "figure.walk" : "figure")
            }
        }
        .toolbar{
            if #available(iOS 26, *) {
                ToolbarItem {
                    Button("Add data", systemImage: "plus"){
                        isShowingAddData = true
                    }
                    .buttonStyle(.glassProminent)
                    .tint(metricColor)
                }
                .matchedTransitionSource(id: "adddata", in: zoomTransition)
                
            }
            else {
                ToolbarItem {
                    Button("Add data", systemImage: "plus"){
                        isShowingAddData = true
                    }
                }
                
            }
            
        }
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                
                LabeledContent(metric.title) {
                    TextField("Value", text : $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $isShowingAlert,
                   error: writeError) { writeError in
                switch writeError {
                case .authNotDetermined, .unableToCompleteRequest, .noData, .invalidValue:
                    EmptyView()
                case .sharingDenied(_):
                    Button("Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    Button("Cancel", role: .cancel) { }
                }
            } message: { writeError in
                Text(writeError.failureReason)
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    if #available(iOS 26, *) {
                        Button(role: .confirm){
                            addDataToHealthKit()
                        }
                        .tint(metricColor)
                    }
                    else {
                        Button("Add Data"){
                            addDataToHealthKit()
                        }
                    }
    }
                ToolbarItem(placement: .topBarLeading){
                    if #available(iOS 26, *) {
                        Button(role: .close){
                            isShowingAddData = false
                        }
                    }
                    else {
                        Button("Dismiss"){
                            isShowingAddData = false
                        }

                    }
                }
        }

        }
    }
    
    func addDataToHealthKit() {
        guard let value = Double(valueToAdd) else {
            writeError = .invalidValue
            isShowingAlert = true
            valueToAdd = ""
            return
        }
        Task {
            if metric == .steps {
                do {
                    if metric == .steps{
                        try await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd)!)
                        hkData.stepData = try await hkManager.fetchStepCount()
                    } else {
                        try await hkManager.addWeightData(for: addDataDate, value: Double(valueToAdd)!)
                        async let weightForLineChart = hkManager.fetchWeights(daysBack: 28)
                        async let weightForDiffChart = hkManager.fetchWeights(daysBack: 29)
                        
                        hkData.weightData = try await weightForLineChart
                        hkData.weightDiffData = try await weightForDiffChart
                    }
                    
                    isShowingAddData = false
                } catch SWError.sharingDenied(let quantityType) {
                    writeError = .sharingDenied(for: quantityType)
                    isShowingAlert = true
                } catch {
                    writeError = .unableToCompleteRequest
                    isShowingAlert = true
                }
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView( metric: .steps)
            .environment(HealthKitManager())
    }
   
}
