//
//  NetworkTask.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import Foundation

protocol NetworkTask {
    func cancel()
}

struct DefaultNetworkTask: NetworkTask {
    let dataTask: URLSessionDataTask

    func cancel() {
        dataTask.cancel()
    }
}
