//
//  NFTCollectionListCollectionViewCell.swift
//  FakeNFT
//
//  Created by Nikolay on 17.02.2025.
//

import UIKit

final class NFTCollectionListTableViewCell: UITableViewCell, ReuseIdentifying {

    private lazy var ntfCollectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameAndNftCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfProBold17
        label.textColor = UIColor.textPrimary
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configure(businessObject: NFTCollectionBusinessObject) {
        nameAndNftCountLabel.text = "\(businessObject.name.capitalized) (\(businessObject.nftCount))"
        ntfCollectionImageView.kf.setImage(with: businessObject.imageURL)
    }

    // MARK: - Private Methods
    private func setupLayout() {

        contentView.addSubview(ntfCollectionImageView)
        contentView.addSubview(nameAndNftCountLabel)

        NSLayoutConstraint.activate([
            ntfCollectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ntfCollectionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ntfCollectionImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            ntfCollectionImageView.bottomAnchor.constraint(equalTo: nameAndNftCountLabel.topAnchor, constant: -4),
            nameAndNftCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
