//
//  UIStackView+Ext.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import UIKit

extension UIStackView {
    static func createNewStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        return stackView
    }
    
    func fillWithParameters(headline: String, field: String) {
        lazy var headlineLabel: UILabel = {
            let headlineLabel = UILabel()
            headlineLabel.font = .systemFont(ofSize: 12)
            headlineLabel.textColor = .white.withAlphaComponent(0.5)
            headlineLabel.text = headline
            return headlineLabel
        }()
        
        lazy var fieldLabel: UILabel = {
            let fieldLabel = UILabel()
            fieldLabel.font = .systemFont(ofSize: 16)
            fieldLabel.textColor = .white
            fieldLabel.text = field
            return fieldLabel
        }()
        
        [headlineLabel, fieldLabel].forEach {
            self.addArrangedSubview($0)
        }
    }
    
    func addSeparator() {
        let separator = UIView()
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = .white.withAlphaComponent(0.1)
        self.addArrangedSubview(separator)
        separator.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
