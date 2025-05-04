//
//  NFTCollectionListViewController.swift
//  Super easy dev
//
//  Created by Nikolay on 16.02.2025
//

import UIKit

protocol NFTCollectionListViewProtocol: AnyObject {
    func updateForNewData()
    func showError(error: Error)
}

final class NFTCollectionListViewController: UIViewController, ErrorView, LoadingView {

    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var nftCollectionListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NFTCollectionListTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 187
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Public
    var presenter: NFTCollectionListPresenterProtocol?

    // MARK: - Private
    private let cellIdentifier = "nftCollectionCellIdentifier"
    private var isLoading  = false

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        presenter?.loadNextPageNFTCollectionList()
        setupLayout()
    }

    private func setupLayout() {

        view.addSubview(nftCollectionListTableView)
        view.addSubview(activityIndicator)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            nftCollectionListTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            nftCollectionListTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            nftCollectionListTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            nftCollectionListTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "CatalogSortButtonImage"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = UIColor.navigationBarButton
        navigationItem.backBarButtonItem?.tintColor = UIColor.navigationBarButton
        navigationItem.backButtonTitle = ""
    }

    @objc func sortButtonTapped() {

        let nameSortModel = FilterMenuButtonModel(title: "По названию", action: {
            self.presenter?.sortNftCollectionList(type: .name)
        })
        let nftCountSortModel = FilterMenuButtonModel(title: "По количеству NFT", action: {
            self.presenter?.sortNftCollectionList(type: .nftCount)
        })
        let buttons = [nameSortModel, nftCountSortModel]
        let filterViewController = FilterViewController(buttons: buttons)
        filterViewController.modalPresentationStyle = .overFullScreen
        present(filterViewController, animated: false)
    }
}

extension NFTCollectionListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfNFTCollections ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NFTCollectionListTableViewCell = tableView.dequeueReusableCell()
        if let businessObject = presenter?.nftCollectionBusinessObjectForIndex(indexPath) {
            cell.configure(businessObject: businessObject)
        }
        return cell
    }
}

extension NFTCollectionListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showNftCollectionDetailForIndexPath(indexPath)
    }
}

// MARK: - NFTCollectionListViewProtocol
extension NFTCollectionListViewController: NFTCollectionListViewProtocol {
    func updateForNewData() {
        hideLoading()
        nftCollectionListTableView.reloadData()
        isLoading = false
    }

    func showError(error: Error) {
        hideLoading()
        let errorModel = ErrorModel(message: error.localizedDescription, actionText: "OK", action: {})
        showError(errorModel)
    }
}

extension NFTCollectionListViewController: UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if scrollView == nftCollectionListTableView {
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
                if !isLoading {
                    print("Loading is false")
                    isLoading = true
                    presenter?.loadNextPageNFTCollectionList()
                }
            }
        }
    }
}
