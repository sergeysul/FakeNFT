import UIKit

final class PaymentMethodCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    private let currencyImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.backgroundColor = UIColor.projectBlack
        return view
    }()

    private let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private let currencyShortNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.greenUniversal
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        deselectCell()
    }

    func configure(
        imageUrlString: String,
        currencyName: String,
        currencyShortName: String
    ) {
        ImageFetcher.shared.fetchImage(from: imageUrlString) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                self.currencyImageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        currencyNameLabel.text = currencyName
        currencyShortNameLabel.text = currencyShortName
    }

    func selectCell() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.projectBlack.cgColor
    }

    func deselectCell() {
        layer.borderWidth = 0
    }

    private func setupUI() {
        setupConstraints()
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 12
        layer.masksToBounds = true
        clipsToBounds = true
    }

    private func setupConstraints() {
        currencyImageView.translatesAutoresizingMaskIntoConstraints = false
        currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyShortNameLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(currencyImageView)
        addSubview(currencyNameLabel)
        addSubview(currencyShortNameLabel)

        NSLayoutConstraint.activate([
            currencyImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            currencyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36),
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),

            currencyNameLabel.bottomAnchor.constraint(equalTo: currencyImageView.centerYAnchor),
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            currencyNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            currencyNameLabel.heightAnchor.constraint(equalToConstant: 18),

            currencyShortNameLabel.topAnchor.constraint(equalTo: currencyImageView.centerYAnchor),
            currencyShortNameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            currencyShortNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            currencyShortNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
