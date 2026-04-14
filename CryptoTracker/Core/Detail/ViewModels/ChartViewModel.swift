//
//  ChartViewModel.swift
//  CryptoTracker
//
//  Created by Ikem Ikekpeazu on 4/9/26.
//

import Foundation
import Combine

class ChartViewModel: ObservableObject {
    
    @Published var chartPoints: [ChartPoint] = []
    
    private let chartDataService: CoinChartDataService
    private var cancellables = Set<AnyCancellable>()
    
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        self.chartDataService = CoinChartDataService(coin: coin)
        
        addSubscribers()
    }
    
    private func addSubscribers() {
        chartDataService.$chartPoints
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedPoints in
                self?.chartPoints = returnedPoints
            }
            .store(in: &cancellables)
    }
    
    var minY: Double {
        chartPoints.map { $0.value }.min() ?? 0
    }
    
    var maxY: Double {
        chartPoints.map { $0.value }.max() ?? 0
    }
    
    var padding: Double {
        (maxY - minY) * 0.3
    }
    
    var priceChange: Double {
        (chartPoints.first?.value ?? 0.0) - (chartPoints.last?.value ?? 0.0)
    }
    
}
