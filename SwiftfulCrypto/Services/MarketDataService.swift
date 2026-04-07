//
//  MarketDataService.swift
//  SwiftfulCrypto
//
//  Created by Ikem Ikekpeazu on 3/24/26.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
   
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global?x_cg_demo_api_key=") else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
            
    }
}
