//
//  HealthDataListView.swift
//  StepWise
//
//  Created by Tarun Sharma on 10/03/26.
//

import SwiftUI

struct HealthDataListView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingAddData = false
    @State private var addDataDate : Date = .now
    @State private var valueToAdd : String = ""
    
    var metric : HealthMetricsContext
    
    var listData: [HealthMetrics] {
        metric == .steps ? hkManager.stepData : hkManager.weightData
    }
    
    var body: some View {
        List(listData.reversed()){ data in
            HStack {
                Text(data.date, format: .dateTime.month().day().year())
                Spacer()
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            }
            
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar{
            Button("Add data", systemImage: "plus"){
                isShowingAddData = true
            }
        }
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text : $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
                
            }
            .navigationTitle(metric.title)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add Data"){
                        Task {
                            if metric == .steps {
                                do {
                                    try await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd)!)
                                    try await hkManager.fetchStepCount()
                                    isShowingAddData = false
                                } catch SWError.sharingDenied(let quantityType) {
                                    print("Sharing denied for - \(quantityType)")
                                } catch {
                                    print("DataListView: Unable to compelte request")
                                }
                               
                            }
                            else {
                                do {
                                    try await hkManager.addWeightData(for: addDataDate, value: Double(valueToAdd)!)
                                    try await hkManager.fetchWeights()
                                    try await hkManager.fetchWeightForDifferentials()
                                    isShowingAddData = false
                                } catch SWError.sharingDenied(let quantityType) {
                                    print("Sharing denied for - \(quantityType)")
                                } catch {
                                    print("DataListView: Unable to compelte request")
                                }

                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading){
                    Button("Dismiss"){
                        isShowingAddData = false
                    }
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
