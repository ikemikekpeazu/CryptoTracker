//
//  ChartRange.swift
//  CryptoTracker
//
//  Created by Ikem Ikekpeazu on 4/14/26.
//
import Foundation

enum ChartRange: String, CaseIterable {
    case oneDay = "1D"
    case oneWeek = "1W"
    case oneMonth = "1M"
    case threeMonth = "3M"
    case sixMonth = "6M"
    case ytd = "YTD"
    case oneYear = "1Y"
    case twoYear = "2Y"
    case fiveYear = "5Y"
    case tenYear = "10Y"
    
    var startDate: Date {
        let now = Date()
        let calendar = Calendar.current
        
        switch self {
        case .oneDay:
            return calendar.date(byAdding: .day, value: -1, to: now)!
            
        case .oneWeek:
            return calendar.date(byAdding: .day, value: -7, to: now)!
            
        case .oneMonth:
            return calendar.date(byAdding: .month, value: -1, to: now)!
            
        case .threeMonth:
            return calendar.date(byAdding: .month, value: -3, to: now)!
        
        case .sixMonth:
            return calendar.date(byAdding: .month, value: -6, to: now)!
        
        case .ytd:
            return calendar.date(from: calendar.dateComponents([.year], from: now))!
        
        case .oneYear:
            return calendar.date(byAdding: .year, value: -1, to: now)!
        
        case .twoYear:
            return calendar.date(byAdding: .year, value: -2, to: now)!
        
        case .fiveYear:
            return calendar.date(byAdding: .year, value: -5, to: now)!
        
        case .tenYear:
            return calendar.date(byAdding: .year, value: -10, to: now)!
            
        
        }
    }
    
    var interval: String {
        switch self {
        case .oneDay: return "5min"
        case .oneWeek: return "15min"
        case .oneMonth: return "1h"
        case .threeMonth: return "1day"
        case .sixMonth: return "1day"
        case .ytd: return "1day"
        case .oneYear: return "1week"
        case .twoYear: return "1week"
        case .fiveYear: return "1month"
        case .tenYear: return "1month"
        }
    }
    
    
}
