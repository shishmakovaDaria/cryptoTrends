//
//  CoinService.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import Foundation

private struct GetCoinsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://api.coincap.io/v2/assets/?limit=10&offset=" + offset)
    }
    var httpMethod: HttpMethod { .get }
    
    var offset: String
    
    init(offset: String) {
        self.offset = offset
    }
}

final class CoinService {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getCoins(offset: String, completion: @escaping (Result<[CoinModel], Error>) -> Void) {
        let getCoinsRequest = GetCoinsRequest(offset: offset)
        
        networkClient.send(request: getCoinsRequest, type: GetCoinsResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(.success(response.data))
                case .failure(let error):
                    print("error \(error)")
                }
            }
        }
    }
}
