//
//  ViewController.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import UIKit
import SnapKit

final class TrendsViewController: UIViewController {
    
    //MARK: - Layout properties
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage.background
        backgroundImageView.contentMode = .scaleToFill
        return backgroundImageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Trending Coins"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "SFNSExpanded-Bold", size: 24)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    private lazy var searchButton: UIButton = {
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.tintColor = .white
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        searchButton.layer.cornerRadius = 12
        searchButton.layer.masksToBounds = true
        return searchButton
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = 72
        tableView.register(TrendsCell.self, forCellReuseIdentifier: TrendsCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.indicatorStyle = .white
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        searchBar.placeholder = "Search"
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.tintColor = .white
        searchBar.searchTextField.layer.cornerRadius = 12
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.returnKeyType = .default
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.showsCancelButton = true
        searchBar.tintColor = .white.withAlphaComponent(0.5)
        searchBar.delegate = self
        return searchBar
    }()

    //MARK: - Properties
    var viewModel: TrendsViewModel
    
    //MARK: - LifeCycle
    init(viewModel: TrendsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupUI()
        setupConstraints()
    }
    
    //MARK: - Actions
    @objc private func refresh() {
        if viewModel.inSearchMode() == false {
            viewModel.refreshCoins()
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    @objc private func searchButtonTapped() {
        setupNavigationBar(shouldHideSearchBar: false)
        searchBar.becomeFirstResponder()
    }
    
    //MARK: - Methods
    private func bind() {
        viewModel.$filtederedCoins.bind { [weak self] _ in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func setupNavigationBar(shouldHideSearchBar: Bool) {
        if shouldHideSearchBar {
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: searchButton)
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: searchBar)
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func setupUI() {
        setupNavigationBar(shouldHideSearchBar: true)
        view.insertSubview(backgroundImageView, at: 0)
        
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
}

//MARK: - UITableViewDataSource
extension TrendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filtederedCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrendsCell.reuseIdentifier, for: indexPath) as? TrendsCell else { return UITableViewCell()}
        
        let coin = viewModel.filtederedCoins[indexPath.row]
        cell.configureCell(with: coin)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TrendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = viewModel.filtederedCoins[indexPath.row]
        let viewModel = SingleCoinViewModel(coin: coin)
        let viewController = SingleCoinViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.inSearchMode() == false &&
            indexPath.row == viewModel.filtederedCoins.count - 1 {
            viewModel.getCoinsFromNetwork()
        }
    }
}

//MARK: - UISearchBarDelegate
extension TrendsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        setupNavigationBar(shouldHideSearchBar: true)
        viewModel.showAllCoins()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCoins(searchText: searchBar.searchTextField.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
