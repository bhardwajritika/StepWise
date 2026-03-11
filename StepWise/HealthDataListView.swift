//
//  HealthDataListView.swift
//  StepWise
//
//  Created by Tarun Sharma on 10/03/26.
//

import SwiftUI

struct HealthDataListView: View {
    
    @State private var isShowingAddData = false
    @State private var addDataDate : Date = .now
    @State private var addDataValue : String = ""
    
    var metric : HealthMetricsContext
    
    var body: some View {
        List(0..<28){ i in
            HStack {
                Text(Date(), format: .dateTime.month().day().year())
                Spacer()
                Text(1000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
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
                    TextField("Value", text : $addDataValue)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
                
            }
            .navigationTitle(metric.title)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add Data"){
                        
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
        HealthDataListView(metric: .steps)
    }
   
}
