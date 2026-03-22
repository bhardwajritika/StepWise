//
//  HealthKitPermissionPrimingView.swift
//  StepWise
//
//  Created by Tarun Sharma on 11/03/26.
//

import SwiftUI
import HealthKitUI

struct HealthKitPermissionPrimingView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingHealthKitPermissions: Bool = false
    
    var description = """
This app displays your steps and weight data in interactive charts.

You can also add new steps and weight data to Apple Health through this app. Your data is private and secure.
"""
    var body: some View {
        VStack(spacing: 130){
            VStack (alignment: .leading, spacing: 10 ){
                Image(.appleHealth)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3),radius: 16)
                    .padding(.bottom, 12)
                
                Text("Apple Health Intergration")
                    .font(.title2).bold()
                
                Text(description)
            }
            
            Button("Connect Apple Health") {
                isShowingHealthKitPermissions = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(30)
        .interactiveDismissDisabled()
        .healthDataAccessRequest(store: hkManager.store,
                                 shareTypes: hkManager.type,
                                 readTypes: hkManager.type,
                                 trigger: isShowingHealthKitPermissions) { result in
            switch result {
            case .success(_):
                dismiss()
            case .failure(_):
                dismiss()
            }
        }
    }
}

#Preview {
    HealthKitPermissionPrimingView()
        .environment(HealthKitManager())
}
