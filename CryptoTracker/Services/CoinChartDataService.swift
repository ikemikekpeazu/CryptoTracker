//
//  CoinChartDataService.swift
//  CryptoTracker
//
//  Created by Ikem Ikekpeazu on 4/8/26.
//

import Foundation
import Combine

class CoinChartDataService {
    
    @Published var chartPoints: [ChartPoint] = []
    var coinChartDataSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getChartData()
    }
   
    func getChartData() {
        guard let url = URL(string: createURL()) else { return }
        
        coinChartDataSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinChartModel.self, decoder: JSONDecoder())
            .map { [weak self] model in
                self?.mapToChartPoints(from: model) ?? []
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedChartPoints) in
                self?.chartPoints = returnedChartPoints
//                print("\(returnedChartPoints.count)")
                self?.coinChartDataSubscription?.cancel()
            })
            
    }
    
    private func mapToChartPoints(from model: CoinChartModel) -> [ChartPoint] {
        guard let values = model.values else { return [] }
         return values.compactMap { value in
//            guard
//                let close = value.close,
//                let datetime = value.datetime,
//                let price = Double(close),
//                let date = dateFormatter.date(from: datetime)
//             else {
//                print("Did not successfully map")
//                return nil
//            }
             guard let close = value.close else {
                 print("Couldn't get close non optional")
                 return nil
             }
             guard let datetime = value.datetime else {
                 print("Couldn't get datetime non optional")
                 return nil
             }
             guard let price = Double(close) else {
                 print("Couldn't get price")
                 return nil
             }
             guard let date = dateFormatter.date(from: datetime) else {
                 print("Couldn't get date", datetime)
                 return nil
             }
             print("Success")
            return ChartPoint(date: date, value: price)
        }
    }
    
    private func createURL() -> String {
        let now = Date()
        let start = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        
        let startString = dateFormatter.string(from: start)
        let endString = dateFormatter.string(from: now)
        
        return "https://api.twelvedata.com/time_series?symbol=\(coin.symbol)/USD&interval=5min&timezone=America/New_York&start_date=\(startString)&end_date=\(endString)&apikey=3d7e79efc6604a1fa500406353774531"
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    
}
