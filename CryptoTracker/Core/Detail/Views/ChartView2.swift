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
            
            Picker("Timeframe", selection: $vm.selectedRange) {
                ForEach(ChartRange.allCases, id: \.self) { x in
                    Text(x.rawValue).tag(x)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            VStack(spacing: 4) {
                if let selectedDate, let point = vm.chartPoints.min(by: {
                    abs($0.date.timeIntervalSince(selectedDate)) < abs($1.date.timeIntervalSince(selectedDate))
                }) {
                    
                    Text(point.date, format: dateFormat)
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
                
                RuleMark(y: .value("Baseline", vm.minY - vm.padding * 0.2))
                    .foregroundStyle(.gray.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 0.2))
                
            }
            .frame(height: 200)
            //        .padding(.horizontal, 10)
            .foregroundStyle(.clear)
            .chartXSelection(value: $selectedDate)
            .chartYScale(domain: (vm.minY - vm.padding * 0.2)...(vm.maxY + vm.padding))
            .chartXAxis {
                AxisMarks(values: .stride(by: xAxisStride, count: xAxisCount)) { value in
                    
                    AxisGridLine()
                        .foregroundStyle(.gray.opacity(0.3))
                    
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date, format: xAxisFormat)
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
    
    private var xAxisStride: Calendar.Component {
        switch vm.selectedRange {
        case .oneDay:
            return .hour
        case .oneWeek, .oneMonth:
            return .day
        case .threeMonth, .sixMonth:
            return .month
        case .oneYear, .ytd:
            return .month
        case .twoYear, .fiveYear, .tenYear:
            return .year
        }
    }

    private var xAxisCount: Int {
        switch vm.selectedRange {
        case .oneDay:
            return 4
        case .oneWeek:
            return 1
        case .oneMonth:
            return 3
        case .threeMonth:
            return 1
        case .sixMonth:
            return 2
        case .oneYear,.ytd:
            return 1
        case .twoYear, .fiveYear, .tenYear:
            return 1
        }
    }

    private var xAxisFormat: Date.FormatStyle {
        switch vm.selectedRange {
        case .oneDay:
            return .dateTime.hour()
        case .oneWeek, .oneMonth:
            return .dateTime.day()
        case .threeMonth, .sixMonth:
            return .dateTime.month(.abbreviated)
        case .oneYear, .ytd:
            return .dateTime.month()
        case .twoYear, .fiveYear, .tenYear:
            return .dateTime.year()
        }
    }
    
    private var dateFormat: Date.FormatStyle {
        switch vm.selectedRange {
        case .oneDay:
            return .dateTime.month(.abbreviated).day().year().hour().minute()
            
        case .oneWeek:
            return .dateTime.month(.abbreviated).day().year().hour().minute()
            
        case .oneMonth:
            return .dateTime.month(.abbreviated).day().year()
            
        case .threeMonth, .sixMonth, .ytd, .oneYear, .twoYear, .fiveYear, .tenYear:
            return .dateTime.month(.abbreviated).day().year()
            
        
        }
    }
    
}

#Preview {
    ChartView2(coin: DeveloperPreview.instance.coin)
}
