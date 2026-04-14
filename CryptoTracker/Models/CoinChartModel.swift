//
//  CoinChartModel.swift
//  CryptoTracker
//
//  Created by Ikem Ikekpeazu on 4/8/26.
//

import Foundation
import Combine

/*
URL: https://api.twelvedata.com/time_series?symbol=BTC/USD&interval=1min&timezone=America/New_York&start_date=2026-04-08T11:50:00&end_date=2026-04-08T12:31:00&apikey=3d7e79efc6604a1fa500406353774531

 {
     "meta": {
         "symbol": "BTC/USD",
         "interval": "1min",
         "currency_base": "Bitcoin",
         "currency_quote": "US Dollar",
         "exchange": "Coinbase Pro",
         "type": "Digital Currency"
     },
     "values": [
         {
             "datetime": "2026-04-08 12:30:00",
             "open": "71379.97",
             "high": "71382.96",
             "low": "71264.73",
             "close": "71293.73"
         },
         {
             "datetime": "2026-04-08 12:29:00",
             "open": "71423.79",
             "high": "71466",
             "low": "71393.45",
             "close": "71398.97"
         },
         {
             "datetime": "2026-04-08 11:59:00",
             "open": "71316.07",
             "high": "71316.37",
             "low": "71286.57",
             "close": "71309.99"
         },
         {
             "datetime": "2026-04-08 11:58:00",
             "open": "71301.9",
             "high": "71316.07",
             "low": "71280",
             "close": "71316.07"
         },
         {
             "datetime": "2026-04-08 11:57:00",
             "open": "71329.24",
             "high": "71333.86",
             "low": "71295.98",
             "close": "71301.64"
         },
         {
             "datetime": "2026-04-08 11:56:00",
             "open": "71291.36",
             "high": "71347.94",
             "low": "71291.35",
             "close": "71329.25"
         },
         {
             "datetime": "2026-04-08 11:55:00",
             "open": "71294.84",
             "high": "71303.66",
             "low": "71267.05",
             "close": "71291.36"
         },
         {
             "datetime": "2026-04-08 11:54:00",
             "open": "71272.14",
             "high": "71303.65",
             "low": "71258.65",
             "close": "71293.88"
         },
         {
             "datetime": "2026-04-08 11:53:00",
             "open": "71232",
             "high": "71290.02",
             "low": "71232",
             "close": "71275.5"
         },
         {
             "datetime": "2026-04-08 11:52:00",
             "open": "71235.17",
             "high": "71235.17",
             "low": "71208.31",
             "close": "71227.83"
         },
         {
             "datetime": "2026-04-08 11:51:00",
             "open": "71272.13",
             "high": "71285.3",
             "low": "71220.56",
             "close": "71235.17"
         },
         {
             "datetime": "2026-04-08 11:50:00",
             "open": "71272.13",
             "high": "71297.52",
             "low": "71248.55",
             "close": "71275.06"
         }
     ],
     "status": "ok"
 }
 
*/


struct CoinChartModel: Codable {
    let meta: Meta?
    let values: [CoinChartData]?
    let status: String?
}

struct Meta: Codable {
    let symbol: String?
    let interval: String?
}

struct CoinChartData: Codable {
    let datetime: String?
    let open: String?
    let high: String?
    let low: String?
    let close: String?
    
}

struct ChartPoint: Identifiable {
    let id = UUID().uuidString
    let date: Date
    let value: Double
    
}



