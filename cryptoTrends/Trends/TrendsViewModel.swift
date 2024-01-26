//
//  TrendsViewModel.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import Foundation

final class TrendsViewModel {
    
    //MARK: - Observables
    @Observable
    private(set) var filtederedCoins: [CoinModel] = []
    
    //MARK: - Properties
    private let coinService: CoinService
    private var allCoins: [CoinModel] = []
    
    //MARK: - LifeCycle
    init(coinService: CoinService = CoinService()) {
        self.coinService = coinService
        getCoinsFromNetwork()
    }
    
    //MARK: - Methods
    func refreshCoins() {
        allCoins = []
        filtederedCoins = allCoins
        getCoinsFromNetwork()
    }
    
    func getCoinsFromNetwork() {
        coinService.getCoins(offset: String(allCoins.count)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let newCoins):
                for coin in newCoins {
                    self.allCoins.append(coin)
                }
                filtederedCoins = allCoins
            case .failure(let error):
                print("Ошибка сети: \(error)")
            }
        }
    }
    
    func filterCoins(searchText: String) {
        filtederedCoins = allCoins.filter { coin in
            if searchText.isEmpty { return true }
            let textCondition = coin.id.contains(searchText.lowercased()) ||
                                coin.symbol.lowercased().contains(searchText.lowercased())
            
            return textCondition
        }
    }
    
    func showAllCoins() {
        filtederedCoins = allCoins
    }
    
    func inSearchMode() -> Bool {
        filtederedCoins.count == allCoins.count ? false : true
    }
}
