//
//  ContentView.swift
//  StepWise
//
//  Created by Tarun Sharma on 06/03/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Label("Steps", systemImage: "figure.walk")
                                    .font(.title3.bold())
                                    .foregroundStyle(.pink)
                                
                                Text("Avg: 10k steps")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                            }
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)

                        }
                        .padding(.bottom, 12)
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 150)
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
                .padding()
            }
            .padding()
            .navigationTitle(Text("Dashboard"))
        }
    }
}

#Preview {
    ContentView()
}
