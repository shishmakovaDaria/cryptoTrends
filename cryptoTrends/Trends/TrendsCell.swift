//
//  TrendsCell.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import UIKit

final class TrendsCell: UITableViewCell {
    
    //MARK: - Layout properties
    private lazy var selectedBackground: UIView = {
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = .white.withAlphaComponent(0.1)
        return selectedBackground
    }()
    
    private lazy var coinImageView: UIImageView = {
        let coinImageView = UIImageView()
        coinImageView.layer.masksToBounds = true
        coinImageView.layer.cornerRadius = 12
        coinImageView.backgroundColor = .white.withAlphaComponent(0.1)
        return coinImageView
    }()
    
    private lazy var nameStackView: UIStackView = {
        let nameStackView = UIStackView()
        nameStackView.axis = .vertical
        nameStackView.alignment = .fill
        nameStackView.spacing = 2
        nameStackView.distribution = .fillEqually
        return nameStackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    private lazy var symbolLabel: UILabel = {
        let symbolLabel = UILabel()
        symbolLabel.font = .systemFont(ofSize: 14)
        symbolLabel.textColor = .white.withAlphaComponent(0.5)
        return symbolLabel
    }()
    
    private lazy var priceStackView: UIStackView = {
        let priceStackView = UIStackView()
        priceStackView.axis = .vertical
        priceStackView.alignment = .trailing
        priceStackView.spacing = 2
        priceStackView.distribution = .fillEqually
        return priceStackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: 16)
        priceLabel.textColor = .white
        return priceLabel
    }()
    
    private lazy var percentLabel: UILabel = {
        let percentLabel = UILabel()
        percentLabel.font = .systemFont(ofSize: 14)
        return percentLabel
    }()
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configureCell(with coin: CoinModel) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        priceLabel.text = coin.priceUsd.createPriceString()
        setupPercentLabel(with: coin.changePercent24Hr)
        coinImageView.image = UIImage(named: "\(coin.symbol.lowercased())") ?? UIImage(named: "gbyte")
    }
    
    private func setupPercentLabel(with changePercent: String) {
        let changePercentDouble = Double(changePercent) ?? 0
        
        percentLabel.textColor = (changePercentDouble >= 0) ? .trendingCoins.green : .trendingCoins.red
        percentLabel.text = changePercent.createPercentString()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.selectedBackgroundView = selectedBackground
        
        [coinImageView, nameStackView, priceStackView].forEach {
            contentView.addSubview($0)
        }
        
        [nameLabel, symbolLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
        
        [priceLabel, percentLabel].forEach {
            priceStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        coinImageView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.top.bottom.equalTo(contentView).inset(12)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.leading.equalTo(coinImageView.snp.trailing).offset(10)
            make.centerY.equalTo(coinImageView)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.centerY.equalTo(nameStackView)
            make.trailing.equalTo(contentView.snp.trailing).inset(20)
        }
    }
}
