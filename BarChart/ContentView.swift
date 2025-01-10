//
//  ContentView.swift
//  BarChart
//
//  Created by Maxim Dmitrochenko on 1/9/25.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    @State private var rawSelectedDate: Date?
    
    var selectedViewMonth: ViewMonth? {
        guard let rawSelectedDate else { return nil }
        return viewMonth.first {
            Calendar.current.isDate(rawSelectedDate, equalTo: $0.date, toGranularity: .month)
        }
    }
    
    let viewMonth: [ViewMonth] = [
        .init(date: Date.from(year: 2025, month: 1, day: 1), viewCount: 94000),
        .init(date: Date.from(year: 2025, month: 2, day: 1), viewCount: 53000),
        .init(date: Date.from(year: 2025, month: 3, day: 1), viewCount: 73000),
        .init(date: Date.from(year: 2025, month: 4, day: 1), viewCount: 74000),
        .init(date: Date.from(year: 2025, month: 5, day: 1), viewCount: 91000),
        .init(date: Date.from(year: 2025, month: 6, day: 1), viewCount: 91000),
        .init(date: Date.from(year: 2025, month: 7, day: 1), viewCount: 86000),
        .init(date: Date.from(year: 2025, month: 8, day: 1), viewCount: 65000),
        .init(date: Date.from(year: 2025, month: 9, day: 1), viewCount: 63000),
        .init(date: Date.from(year: 2025, month: 10, day: 1), viewCount: 59000),
        .init(date: Date.from(year: 2025, month: 11, day: 1), viewCount: 79000),
        .init(date: Date.from(year: 2025, month: 12, day: 1), viewCount: 83000),
    ]
    
    var body: some View {
        ScrollView {
            VStack (spacing: 10) {
                
                Text("YouTube Views")
                
                Text("Total: \(viewMonth.reduce(0, { $0 + $1.viewCount}))")
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
                
                Chart {
                    /// Chart work like ZStack and green rule mark could be before the bars
                    //                RuleMark(y: .value("Median", 80000))
                    //                    .foregroundStyle(.green)
                    //                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    
                    if let selectedViewMonth {
                        RuleMark(x: .value("Selected Month", selectedViewMonth.date, unit: .month))
                            .foregroundStyle(.secondary.opacity(0.3))
                            .annotation(position: .top,  overflowResolution: .init(x: .fit(to: .plot), y: .disabled)) {
                                VStack {
                                    Text(selectedViewMonth.date, format: .dateTime.month(.wide))
                                        .bold()
                                    
                                    Text("\(selectedViewMonth.viewCount)")
                                        .font(.title3.bold())
                                }
                                .foregroundStyle(.white)
                                .padding(12)
                                .frame(width: 120)
                                .background(RoundedRectangle(cornerRadius: 12)
                                    .fill(.pink.gradient)
                                            )
                            }
                    }
                    
                    ForEach(viewMonth) { viewMonth in
                        BarMark(
                            x: .value("Month", viewMonth.date, unit: .month),
                            y: .value("Views", viewMonth.viewCount)
                        )
                        .foregroundStyle(.pink.gradient)
                        .cornerRadius(3)
                        .opacity(rawSelectedDate == nil || viewMonth.date == selectedViewMonth?.date ? 1.0 : 0.3)
                    }
                    
                    RuleMark(y: .value("AVG", calculateAverage(viewMonth)))
                        .foregroundStyle(.secondary)
                        .annotation {
                            Text("AVG")
                                .font(.system(size: 10, weight: .regular, design: .rounded))
                                .foregroundStyle(.white)
                                .font(.caption)
                                .padding(5)
                                .background(.gray)
                                .cornerRadius(10)
                        }
                    RuleMark(y: .value("Goal", 50000))
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .annotation {
                            Text("Goal")
                                .font(.system(size: 10, weight: .regular, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(5)
                                .background(.green)
                                .cornerRadius(10)
                        }
                }
                .frame(height: 180)
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                .chartXAxis {
                    AxisMarks(values: viewMonth.map { $0.date }) { date in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.month(.narrow), centered: true)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { mark in
                        AxisGridLine()
                        AxisValueLabel()
                        AxisTick()
                    }
                }
                
                VStack (alignment: .leading) {
                    HStack {
                        Image(systemName: "line.diagonal")
                            .rotationEffect(Angle(degrees: 45))
                            .foregroundStyle(.green)
                        Text("Monthly Goal")
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption2)
                    
                    HStack {
                        Image(systemName: "line.diagonal")
                            .rotationEffect(Angle(degrees: 45))
                            .foregroundStyle(.gray)
                        Text("Average Views")
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption2)
                }

                
                Chart {
                    ForEach(viewMonth) { viewMonth in
                        LineMark(
                            x: .value("Month", viewMonth.date, unit: .month),
                            y: .value("Views", viewMonth.viewCount)
                        )
                        .foregroundStyle(.blue.gradient)
                    }
                }
                .frame(height: 180)
                .chartPlotStyle { chartPlotContent in
                    chartPlotContent
                        .background(.mint.gradient.opacity(0.3))
                        .border(.mint, width: 2)
                }
                
                Chart {
                    ForEach(viewMonth) { viewMonth in
                        LineMark(
                            x: .value("Month", viewMonth.date, unit: .month),
                            y: .value("Views", viewMonth.viewCount)
                        )
                        .foregroundStyle(.purple.gradient)
                    }
                }
                .frame(height: 180)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartYScale(domain: 0...200000)
                
                Chart {
                    ForEach(viewMonth) { viewMonth in
                        LineMark(
                            x: .value("Month", viewMonth.date, unit: .month),
                            y: .value("Views", viewMonth.viewCount)
                        )
                        .foregroundStyle(.yellow.gradient)
                    }
                }
                .frame(height: 180)
                .chartYScale(domain: 50000...100000)
                
                Chart {
                    ForEach(viewMonth) { viewMonth in
                        BarMark(
                            x: .value("Views", viewMonth.viewCount),
                            y: .value("Month", viewMonth.date, unit: .month)
                        )
                        .foregroundStyle(.green.gradient)
                    }
                }
                .frame(height: 180)
            }
            .padding()
        }
    }
    
    private func calculateAverage(_ viewMonths: [ViewMonth]) -> Int {
        guard !viewMonths.isEmpty else { return 0 }
        
        let totalViews = viewMonths.reduce(0) { $0 + $1.viewCount }
        return totalViews / viewMonths.count
    }
}

#Preview {
    ContentView()
}

struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let viewCount: Int
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
