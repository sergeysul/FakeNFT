import UIKit

final class AgreementAndPayView: UIView {
    var presenter: PaymentPagePresenterProtocol?

    private let agreementTextLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.agreementTextLabel
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private let agreementLinkLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.agreementLinkLabel
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.blueUniversal
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localization.pay, for: .normal)
        button.setTitleColor(UIColor.projectWhite, for: .normal)
        button.backgroundColor = UIColor.projectBlack
        button.layer.cornerRadius = 16
        button.addTarget(self,
                         action: #selector(payButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLinkAgreement()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLinkAgreement() {
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(agreementLinkTapped)
        )
        agreementLinkLabel.addGestureRecognizer(gesture)
    }

    private func setupUI() {
        setupConstraints()
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
    }

    private func setupConstraints() {
        agreementTextLabel.translatesAutoresizingMaskIntoConstraints = false
        agreementLinkLabel.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(agreementLinkLabel)
        addSubview(agreementTextLabel)
        addSubview(payButton)

        NSLayoutConstraint.activate( [
            agreementTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            agreementTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            agreementTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            agreementTextLabel.heightAnchor.constraint(equalToConstant: 18),

            agreementLinkLabel.topAnchor.constraint(equalTo: agreementTextLabel.bottomAnchor),
            agreementLinkLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            agreementLinkLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            agreementLinkLabel.heightAnchor.constraint(equalToConstant: 26),

            payButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            payButton.topAnchor.constraint(equalTo: agreementLinkLabel.bottomAnchor, constant: 16)
        ])
    }

    @objc
    func agreementLinkTapped() {
        presenter?.showWebView()
    }

    @objc
    func payButtonTapped() {
        presenter?.payButtonTapped()
    }
}
