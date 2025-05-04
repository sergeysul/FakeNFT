//
//  NFTCollectionDetailViewController.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

import UIKit
import Kingfisher

protocol NFTCollectionDetailViewProtocol: AnyObject {
    func updateNftCollectionInformation(name: String, imageURL: URL?, description: String, authorName: String)
    func showError(error: Error)
    func updateNftList()
}

final class NFTCollectionDetailViewController: UIViewController, ErrorView, LoadingView {

    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfProBold22
        label.textColor = UIColor.textPrimary
        return label
    }()

    private lazy var authorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nftCollectionAuthorTitleLabel)
        stackView.addArrangedSubview(nftCollectionAuthorNameLabel)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private lazy var nftCollectionAuthorTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = UIFont.sfRegular15
        label.textColor = UIColor.textPrimary
        label.text = "Автор коллекции: "
        label.textAlignment = .left
        return label
    }()

    private lazy var nftCollectionAuthorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.font = UIFont.sfRegular15
        label.textColor = UIColor.linkText
        label.textAlignment = .left
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onClickLabel))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gestureRecognizer)
        return label
    }()

    private lazy var nftDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfRegular13
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var nftsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NFTCollectionViewCell.self)
        return collectionView
    }()

    @objc private func onClickLabel(sender: UITapGestureRecognizer) {
        presenter?.showAuthorPage()
    }

    // MARK: - Public Properties
    var presenter: NFTCollectionDetailPresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        presenter?.loadCurrentNFTCollection()
        presenter?.loadProfile()
        presenter?.loadOrder()
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var corners: UIRectCorner = []
        corners.update(with: .bottomLeft)
        corners.update(with: .bottomRight)
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: imageView.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: 12, height: 12)
        ).cgPath
        imageView.layer.mask = maskLayer
    }

    // MARK: - Private Methods
    private func setupLayout() {

        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(nftDescriptionLabel)
        view.addSubview(authorStackView)
        view.addSubview(nftsCollectionView)
        view.addSubview(activityIndicator)
        view.backgroundColor = UIColor.background
        navigationItem.backButtonTitle = ""

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 310),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),

            authorStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            authorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            authorStackView.heightAnchor.constraint(equalToConstant: 20),

            nftDescriptionLabel.topAnchor.constraint(equalTo: authorStackView.bottomAnchor, constant: 5),
            nftDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            nftsCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            nftsCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            nftsCollectionView.topAnchor.constraint(equalTo: nftDescriptionLabel.bottomAnchor, constant: 24),
            nftsCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - NFTCollectionDetailViewProtocol
extension NFTCollectionDetailViewController: NFTCollectionDetailViewProtocol {

    func updateNftCollectionInformation(name: String, imageURL: URL?, description: String, authorName: String) {
        nameLabel.text = name
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "Placeholder"))
        nftDescriptionLabel.text = description
        nftCollectionAuthorNameLabel.text = authorName
    }

    func showError(error: Error) {
        hideLoading()
        let errorModel = ErrorModel(message: error.localizedDescription, actionText: "OK", action: {})
        showError(errorModel)
    }

    func updateNftList() {
        hideLoading()
        nftsCollectionView.reloadData()
    }
}

extension NFTCollectionDetailViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {

        return presenter?.nftCount ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell: NFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        if let businessObject = presenter?.nftBusinessObject(index: indexPath) {
            cell.configure(businessObject: businessObject)
        }
        cell.onLikeButtonTapped = { [weak self] nftBusinessObject in
            guard let self = self else { return }
            self.showLoading()
            self.presenter?.updateFavoriteStatus(nftBusinessObject: nftBusinessObject)
        }
        cell.onOrderButtonTapped = { [weak self] nftBusinessObject in
            guard let self = self else { return }
            self.showLoading()
            self.presenter?.updateOrder(nftBusinessObject: nftBusinessObject)
        }
        return cell
    }
}

extension NFTCollectionDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        return CGSize(width: 108, height: 192)
    }
}
