//
//  String+Ext.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import Foundation

extension String {
    func createPriceString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.decimalSeparator = "."

        guard let formattedString = numberFormatter.string(from: NSNumber(value: Double(self) ?? 0)) else { return "" }
        
        return "$ \(formattedString)"
    }
    
    func createPercentString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.decimalSeparator = "."
        numberFormatter.negativePrefix = "- "
        numberFormatter.positivePrefix = "+ "
        
        guard let formattedString = numberFormatter.string(from: NSNumber(value: Double(self) ?? 0)) else { return "" }
        
        return "\(formattedString)%"
    }
    
    func createShortString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.decimalSeparator = "."
        
        guard let number = Double(self) else { return "" }
        
        if number/1_000_000_000 >= 1 {
            guard let formattedString = numberFormatter.string(from: NSNumber(value: number/1_000_000_000)) else { return "" }
            return "$\(formattedString)b"
        } else {
            guard let formattedString = numberFormatter.string(from: NSNumber(value: number/1_000_000)) else { return "" }

            return "\(formattedString)m"
        }
    }
    
    static func createFullPercentString(coin: CoinModel) -> String {
        guard let price = Double(coin.priceUsd) else { return "" }
        guard let changePercent = Double(coin.changePercent24Hr) else { return "" }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.decimalSeparator = "."

        let delta = price*(1-(1/(1+changePercent/100)))
        
        guard let formattedString = numberFormatter.string(from: NSNumber(value: delta)) else { return "" }
        guard let formattedPercent = numberFormatter.string(from: NSNumber(value: changePercent)) else { return "" }
        
        if delta >= 0 {
            return "+ \(formattedString) (\(formattedPercent)%)"
        } else {
            return "- \(formattedString.dropFirst()) (\(formattedPercent.dropFirst())%)"
        }
    }
}
