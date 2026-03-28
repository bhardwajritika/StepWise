//
//  ChartContainer.swift
//  StepWise
//
//  Created by Tarun Sharma on 23/03/26.
//

import SwiftUI

enum ChartType {
    case stepBar(average: Int)
    case stepWeekdayPie
    case weightLine(average: Double)
    case weightDiffBar
}

struct ChartContainer<Content: View >: View {
    
    let chartType: ChartType
    @ViewBuilder var content : () -> Content
    
    var isNav : Bool {
        switch chartType {
        case .stepBar(_), .weightLine(_):
            return true
        case .stepWeekdayPie, .weightDiffBar:
            return false
        }
    }
    
    var context : HealthMetricsContext {
        switch chartType {
        case .stepBar(_), .stepWeekdayPie:
            return .steps
        case .weightLine(_), .weightDiffBar:
            return .weight
        }
    }
    
    var title : String {
        switch chartType {
            case .stepBar(_):
            return "Steps"
        case .stepWeekdayPie:
            return "Average"
        case .weightLine(_):
            return "Weight"
        case .weightDiffBar:
            return "Average Weight Chart"
        }
    }
    
    var symbol : String {
        switch chartType {
        case .stepBar(average: _):
            return "figure.walk"
        case .weightLine(average: _), .weightDiffBar:
            return "figure"
        case .stepWeekdayPie:
            return "calendar"
            
        }
    }
    
    var subtitle : String {
        switch chartType {
        case .stepBar( let average):
            return "Avg: \(average) steps"
        case .stepWeekdayPie:
            return "Last 28 days"
        case .weightLine(let average):
            return "Avg: \(average.formatted(.number.precision(.fractionLength(1)))) lbs"
        case .weightDiffBar:
            return "Per Weekday (Last 28 days)"
        }
    }
    
    var body: some View {
        VStack (alignment: .leading){
            if isNav{
                navigationLinkView
            } else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous)
            .stroke(.gray.opacity(0.5), lineWidth: 0.5)
            .fill(Color(.secondarySystemBackground).gradient.opacity(0.5)))
    }
    
    var navigationLinkView: some View {
        NavigationLink(value: context) {
            HStack {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
        .accessibilityHint("Tap for data in list view")
    }
    
    var titleView : some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: symbol)
                .font(.title3.bold())
                .foregroundStyle(context == .steps ? .pink : .indigo)
            
            Text(subtitle)
                .font(.caption)
        }
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityElement(children: .ignore)
    }
    
    var accessibilityLabel: String {
        switch chartType {
        case .stepWeekdayPie:
            return "Pie chart, average steps per weekday"
        case .weightLine(average: let average):
            return "Line Chart weight, Average weight: \(average.formatted(.number.precision(.fractionLength(1)))) pounds"
        case .weightDiffBar:
            return "Bar chart, average weight per weekday"
        case .stepBar(average: let average):
            return "Bar chart, step count, last 28 days, average steps per day: \(average) steps"
        }
    }
}

#Preview {
    ChartContainer(chartType: .stepWeekdayPie) {
        Text("Chart goes here.")
            .frame(minHeight: 150)
    }
}
