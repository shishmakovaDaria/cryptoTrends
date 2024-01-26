//
//  UITableViewCell+Ext.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import UIKit

protocol Reusable { }

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable { }
