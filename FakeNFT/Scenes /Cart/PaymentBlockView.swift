import UIKit

final class PaymentBlockView: UIView {
    private let payButton: UIButton = {
        let button = UIButton()
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor.projectBlack
        button.setTitleColor(.projectWhite, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()

    private let nftCounterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.greenUniversal
        return label
    }()

    private var buttonAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        totalPrice: String,
        numberOfItems: String,
        buttonAction: @escaping () -> Void
    ) {
        nftCounterLabel.text = "\(numberOfItems) NFT"
        totalPriceLabel.text = "\(totalPrice) ETH"

        self.buttonAction = buttonAction
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        payButton.translatesAutoresizingMaskIntoConstraints = false
        nftCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(payButton)
        addSubview(nftCounterLabel)
        addSubview(totalPriceLabel)

        NSLayoutConstraint.activate([
            nftCounterLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            nftCounterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            nftCounterLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: nftCounterLabel.bottomAnchor, constant: 2),
            totalPriceLabel.leadingAnchor.constraint(equalTo: nftCounterLabel.leadingAnchor),
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 22)
        ])

        NSLayoutConstraint.activate([
            payButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            payButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            payButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }

    @objc private func payButtonTapped() {
        buttonAction?()
    }
}
