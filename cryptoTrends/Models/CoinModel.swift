//
//  CoinModel.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import Foundation

struct CoinModel: Codable {
    let id: String
    let rank: String
    let symbol: String
    let name: String
    let supply: String
    let maxSupply: String?
    let marketCapUsd: String
    let volumeUsd24Hr: String
    let priceUsd: String
    let changePercent24Hr: String
    let vwap24Hr: String?
}

struct GetCoinsResponse: Codable {
    let data: [CoinModel]
}
