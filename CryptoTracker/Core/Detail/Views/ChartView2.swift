//
//  ChartView2.swift
//  CryptoTracker
//
//  Created by Ikem Ikekpeazu on 4/10/26.
//

import SwiftUI
import Charts

struct ChartView2: View {
    let coin: CoinModel
    
    @StateObject private var vm: ChartViewModel
    @State private var selectedDate: Date?
    
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: ChartViewModel(coin: coin))
        
        
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 4) {
                if let selectedDate, let point = vm.chartPoints.min(by: {
                    abs($0.date.timeIntervalSince(selectedDate)) < abs($1.date.timeIntervalSince(selectedDate))
                }) {
                    
                    Text(point.date.formatted(.dateTime.month(.abbreviated).day().year().hour().minute()))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.theme.accent)
                    
                    Text(point.value, format: .number.precision(.fractionLength(2)))
                        .font(.headline)
                        .foregroundStyle(.blue)
                } else {
                    Text("0")   
                        .foregroundStyle(Color.theme.background)
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("0")
                        .foregroundStyle(Color.theme.background)
                        .font(.headline)
//                    Color.clear.frame(height: 40)
                }
            }
            
            
            Chart(vm.chartPoints) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Price", point.value)
                )
                .interpolationMethod(.linear)
                .lineStyle(StrokeStyle(lineWidth: 2))
                //            .foregroundStyle(.green)
                .foregroundStyle(selectedDate != nil ? Color.blue :(vm.priceChange > 0 ? Color.theme.green : Color.theme.red))
                
                if let selectedDate {
                    RuleMark(x: .value("Selected", selectedDate))
                        .foregroundStyle(.blue.opacity(0.5))
//                        .offset(y: -10)
//                        .annotation(position: .top, spacing: 0)
                    
                    if let point = vm.chartPoints.min(by: { abs($0.date.timeIntervalSince(selectedDate)) < abs($1.date.timeIntervalSince(selectedDate))}){
                        PointMark(x: .value("Time", point.date), y: .value("Price", point.value))
                            .foregroundStyle(.black)
                            .symbolSize(200)
                        PointMark(x: .value("Time", point.date), y: .value("Price", point.value))
                            .foregroundStyle(.blue)
                            .symbolSize(100)
                    }
                }
                
                RuleMark(y: .value("Baseline", vm.minY))
                    .foregroundStyle(.gray.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 0.2))
                
            }
            .frame(height: 200)
            //        .padding(.horizontal, 10)
            .foregroundStyle(.clear)
            .chartXSelection(value: $selectedDate)
            .chartYScale(domain: (vm.minY)...(vm.maxY + vm.padding))
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 4)) { value in
                    
                    AxisGridLine()
                        .foregroundStyle(.gray.opacity(0.3))
                    
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date, format: .dateTime.hour())
                        }
                    }
                }
                
            }
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) { value in
                    
                    AxisGridLine()
                        .foregroundStyle(.gray.opacity(0.3))
                    
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(doubleValue, format: .currency(code: "USD"))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.clear)
            }
        }
    }
}

#Preview {
    ChartView2(coin: DeveloperPreview.instance.coin)
}
