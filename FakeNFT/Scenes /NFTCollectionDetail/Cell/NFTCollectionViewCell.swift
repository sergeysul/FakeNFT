//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Nikolay on 03.03.2025.
//

import UIKit

final class NFTCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    var onLikeButtonTapped: ((NftBusinessObject) -> Void)?
    var onOrderButtonTapped: ((NftBusinessObject) -> Void)?

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var nftRatingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfProBold17
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfProMedium10
        label.textColor = UIColor.textPrimary
        return label
    }()

    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        button.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()

    private var currentNftBusinessObject: NftBusinessObject?

    @objc private func likeButtonTapped() {
        if let currentNftBusinessObject = currentNftBusinessObject {
            onLikeButtonTapped?(currentNftBusinessObject)
        }
    }

    @objc private func orderButtonTapped() {

        if let currentNftBusinessObject = currentNftBusinessObject {
            onOrderButtonTapped?(currentNftBusinessObject)
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        currentNftBusinessObject = nil
        nftImageView.kf.cancelDownloadTask()
    }

    // MARK: - Public Methods
    func configure(businessObject: NftBusinessObject) {

        currentNftBusinessObject = businessObject
        nftImageView.kf.setImage(with: businessObject.imageURL, placeholder: UIImage(named: "Placeholder"))
        nftNameLabel.text = businessObject.name
        nftPriceLabel.text = "\(businessObject.price) ETH"
        let likeImage = businessObject.isLiked ? UIImage(named: "Liked") : UIImage(named: "NotLiked")
        likeButton.setImage(likeImage, for: .normal)
        let orderImage = businessObject.isOrdered ? UIImage(named: "Ordered") : UIImage(named: "NotOrdered")
        orderButton.setImage(orderImage, for: .normal)
        nftRatingView.rating = businessObject.rating
    }

    // MARK: - Private Properties
    private func setupLayout() {

        contentView.addSubview(nftImageView)
        contentView.addSubview(nftRatingView)
        contentView.addSubview(nftNameLabel)
        contentView.addSubview(orderButton)
        contentView.addSubview(nftPriceLabel)
        contentView.addSubview(likeButton)

        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: nftRatingView.topAnchor, constant: -8),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftRatingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftRatingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftRatingView.heightAnchor.constraint(equalToConstant: 12),
            nftRatingView.bottomAnchor.constraint(equalTo: nftNameLabel.topAnchor, constant: -4),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: orderButton.leadingAnchor),
            nftNameLabel.bottomAnchor.constraint(equalTo: nftPriceLabel.topAnchor),
            orderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            orderButton.topAnchor.constraint(equalTo: nftRatingView.bottomAnchor, constant: 4),
            orderButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            orderButton.heightAnchor.constraint(equalToConstant: 40),
            orderButton.widthAnchor.constraint(equalToConstant: 40),
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftPriceLabel.trailingAnchor.constraint(equalTo: orderButton.leadingAnchor),
            nftPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftPriceLabel.heightAnchor.constraint(equalToConstant: 12),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
