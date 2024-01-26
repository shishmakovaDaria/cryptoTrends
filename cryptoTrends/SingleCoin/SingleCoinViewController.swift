//
//  SingleCoinViewController.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import UIKit

final class SingleCoinViewController: UIViewController {
    
    //MARK: - Layout properties
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage.background
        backgroundImageView.contentMode = .scaleToFill
        return backgroundImageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = viewModel.coin.name
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "SFNSExpanded-Bold", size: 24)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.tintColor = .white
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        backButton.layer.cornerRadius = 12
        backButton.layer.masksToBounds = true
        return backButton
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: 24)
        priceLabel.textColor = .white
        priceLabel.text = viewModel.coin.priceUsd.createPriceString()
        return priceLabel
    }()
    
    private lazy var percentLabel: UILabel = {
        let percentLabel = UILabel()
        percentLabel.font = .systemFont(ofSize: 14)
        let changePercentDouble = Double(viewModel.coin.changePercent24Hr) ?? 0
        percentLabel.textColor = (changePercentDouble >= 0) ? .trendingCoins.green : .trendingCoins.red
        percentLabel.text = String.createFullPercentString(coin: viewModel.coin)
        return percentLabel
    }()
    
    private lazy var parameterStackView: UIStackView = {
        let parameterStackView = UIStackView()
        parameterStackView.axis = .horizontal
        parameterStackView.alignment = .center
        parameterStackView.spacing = 30
        parameterStackView.distribution = .equalSpacing
        return parameterStackView
    }()
    
    private lazy var marketCapStackView = UIStackView.createNewStackView()
    private lazy var supplyStackView = UIStackView.createNewStackView()
    private lazy var volumeStackView = UIStackView.createNewStackView()
    
    //MARK: - Properties
    var viewModel: SingleCoinViewModel
    
    //MARK: - LifeCycle
    init(viewModel: SingleCoinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    //MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    private func setupUI() {
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem.init(customView: backButton),
            UIBarButtonItem.init(customView: titleLabel)
        ]
        
        view.insertSubview(backgroundImageView, at: 0)
        
        [priceLabel, percentLabel, parameterStackView].forEach {
            view.addSubview($0)
        }
        
        parameterStackView.addArrangedSubview(marketCapStackView)
        parameterStackView.addSeparator()
        parameterStackView.addArrangedSubview(supplyStackView)
        parameterStackView.addSeparator()
        parameterStackView.addArrangedSubview(volumeStackView)
        
        marketCapStackView.fillWithParameters(headline: "Market Cap", field: viewModel.coin.marketCapUsd.createShortString())
        supplyStackView.fillWithParameters(headline: "Supply", field: viewModel.coin.supply.createShortString())
        volumeStackView.fillWithParameters(headline: "Volume 24Hr", field: viewModel.coin.volumeUsd24Hr.createShortString())
    }
    
    func setupConstraints() {
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(37.5)
        }
        
        percentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.leading.equalTo(priceLabel.snp.trailing).offset(10)
        }
        
        parameterStackView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }
    }
}
