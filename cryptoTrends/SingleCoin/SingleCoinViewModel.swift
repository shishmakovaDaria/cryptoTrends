//
//  SingleCoinViewModel.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import Foundation

final class SingleCoinViewModel {
    
    // MARK: - Properties
    private (set) var coin: CoinModel
    
    // MARK: - LifeCycle
    init(coin: CoinModel) {
        self.coin = coin
    }
}
